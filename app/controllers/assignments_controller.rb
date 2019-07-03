class AssignmentsController < ApplicationController

  def index
    @course = Course.find_by_id(params[:course_id])

    add_breadcrumb "Courses", :root_path
    add_breadcrumb @course.name, edit_course_url(@course)
    add_breadcrumb "Assignments"
    
    @assignments = @course.assignments
  end

  def new
    @course = Course.find_by_id(params[:course_id])
    @assignment = Assignment.new course_id: params[:course_id]

    add_breadcrumb "Courses", :root_path
    add_breadcrumb @course.name, edit_course_url(@course)
    add_breadcrumb "New assignment"
  end

  def edit
    @course = Course.find_by_id(params[:course_id])
    @assignment = Assignment.find_by_id(params[:id])

    add_breadcrumb "Courses", :root_path
    add_breadcrumb @course.name, edit_course_url(@course)
    add_breadcrumb "Edit assignment: #{@assignment.name}"

    render :new
  end

  def create
    assignment = Assignment.new assignment_params
    assignment.course_id = params[:course_id]
    assignment.save!

    redirect_to course_assignments_path(params[:course_id])
  end

  def update
    assignment = Assignment.find_by_id(params[:id])
    assignment.attributes = assignment_params
    assignment.course_id = params[:course_id]
    assignment.save!

    redirect_to course_assignments_path(params[:course_id])
  end

  def destroy
    Assignment.find_by_id(params[:id]).destroy

    redirect_to course_assignments_path(params[:course_id])
  end

  def assignment_params
    params.require(:assignment).permit(:name, :cooldown)
  end
end
