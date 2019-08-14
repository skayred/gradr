class TesterWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  # TESTER_SCRIPT = './lib/tester.sh'

  def perform(task_id, source_rep, session, url, user_id)
    task = Assignment.find_by_id task_id

    tester_script = task.script_name

    subm = Submission.new user_id: user_id, assignment_id: task_id, jid: jid, status: :started
    subm.save!

    score = 0

    begin
      `bash #{tester_script} #{source_rep} #{task.test_reps.select(:name).pluck(:name).join(' ')}`

      report = JSON.load File.open('./log/test.log')
      feedback = File.read('./log/output.log')

      scores = []

      report["testResults"].each do |tr|
        tr["assertionResults"].each do |res|
          weight = task.weights.find_by_name res['title']
          puts res['title']
          puts res['status']
          puts (if (res['status'] == 'passed') then (weight.try(:weight) || 1) else 0 end)
          puts (res['status'] == 'passed')
          puts '---------++++'
          scores << (if (res['status'] == 'passed') then (weight.try(:weight) || 1) else 0 end)
        end
      end

      score = (scores.inject{ |sum, el| sum + (el || 0) }.to_f / scores.size) || 0
      score = if score.nan? then 0 else score end
    ensure
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
  end

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end
end
