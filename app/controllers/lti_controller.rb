require 'ims/lti'
require 'oauth'
require 'Haml'
require 'sidekiq/api'

TESTER_SCRIPT = './lib/tester.sh'

class LtiController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def start
    task = Assignment.find_by_id params[:id]
    secret = task.course.user.secret
    authenticator = IMS::LTI::Services::MessageAuthenticator.new(request.url, request.request_parameters, secret)

    unless authenticator.valid_signature?
      render plain: 'Unauthorized. Did you set key and secret from your settings?', status: :unauthorized
    else
      unless params['lis_outcome_service_url'] && params['lis_result_sourcedid']
        render plain: "It looks like this LTI tool wasn't launched as an assignment"
      end

      %w(lis_outcome_service_url lis_result_sourcedid lis_person_name_full lis_person_contact_email_primary user_id).each { |v| session[v] = params[v] }

      redirect_to action: 'show', id: params[:id]
    end
  end

  def show
    unless session['lis_result_sourcedid']
      render plain: "You need to take this assessment through Canvas."
    end

    @task = Assignment.find_by_id params[:id]
    @enabled = (DateTime.now - Submission.last.created_at.to_datetime).to_f*24 >= @task.cooldown
    @sub = Submission.where(assignment_id: @task.id, user_id: session['user_id']).order("created_at").last
  end

  def update
    @session = session['lis_result_sourcedid'].to_s

    source_rep = params[:source]
    if (!source_rep || source_rep.empty?)
      redirect to("/assessment")
    end

    job_id = TesterWorker.perform_async(params[:id], source_rep, @session, session['lis_outcome_service_url'], session['user_id'])

    render plain: 'Pending...'
  end
end