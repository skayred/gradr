class TestRepsController < ApplicationController
  def index
    @course = Course.find_by_id(params[:course_id])
    @assignment = Assignment.find_by_id(params[:assignment_id])
    @reps = @assignment.test_reps
  end

  def new
    @rep = TestRep.new
    @course = Course.find_by_id(params[:course_id])
    @assignment = Assignment.find_by_id(params[:assignment_id])
  end

  def edit
    @rep = TestRep.find_by_id(params[:id])
    @course = Course.find_by_id(params[:course_id])
    @assignment = Assignment.find_by_id(params[:assignment_id])

    render :new
  end

  def create
    rep = TestRep.new rep_params
    rep.assignment_id = params[:assignment_id]
    rep.save!

    redirect_to course_assignment_test_reps_path(params[:course_id], params[:assignment_id])
  end

  def update
    course = TestRep.find_by_id(params[:id])
    course.attributes = rep_params
    course.save!

    redirect_to course_assignment_test_reps_path(params[:course_id], params[:assignment_id])
  end

  def destroy
    TestRep.find_by_id(params[:id]).destroy

    redirect_to course_assignment_test_reps_path(params[:course_id], params[:assignment_id])
  end

  def rep_params
    params.require(:test_rep).permit(:name, :is_secret)
  end
end
