class TesterWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  TESTER_SCRIPT = './lib/tester.sh'

  def perform(task_id, source_rep, session, url, user_id)
    task = Assignment.find_by_id task_id

    subm = Submission.new user_id: user_id, assignment_id: task_id, jid: jid, status: :started
    subm.save!

    `bash #{TESTER_SCRIPT} #{source_rep} #{task.test_reps.select(:name).pluck(:name).join(' ')}`

    report = JSON.load File.open('./log/test.log')
    feedback = File.read('./log/output.log')

    puts report

    score = report['numPassedTestSuites'] / (report['numFailedTestSuites'] + report['numPassedTestSuites'])

    consumer = OAuth::Consumer.new(task.course.user.key, task.course.user.secret)
    token = OAuth::AccessToken.new(consumer)

    template = File.read('./app/views/score_response.haml')
    xml_response = Haml::Engine.new(template).render(Object.new, { session: session, score: score })

    subm.status = :finished
    subm.score = score
    subm.feedback = feedback
    subm.save!

    response = token.post(url, xml_response, 'Content-Type' => 'application/xml')

    puts %{
      Your score has #{response.body.match(/\bsuccess\b/) ? "been posted" : "failed in posting"} to Canvas. The response was:

      #{response.body}
        }
  end

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end
end
