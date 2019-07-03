class CoursesController < ApplicationController

  def index
    add_breadcrumb "Courses"
    @courses = current_user.courses
  end

  def new
    add_breadcrumb "Courses", :root_path
    add_breadcrumb "New course"
    @course = Course.new
  end

  def edit
    @course = Course.find_by_id(params[:id])

    add_breadcrumb "Courses", :root_path
    add_breadcrumb "Edit course: #{@course.name}"

    render :new
  end

  def create
    course = Course.new course_params
    course.user_id = current_user.id
    course.save!

    redirect_to courses_path
  end

  def update
    course = Course.find_by_id(params[:id])
    course.attributes = course_params
    course.save!

    redirect_to courses_path
  end

  def destroy
    Course.find_by_id(params[:id]).destroy

    redirect_to courses_path
  end

  def course_params
    params.require(:course).permit(:name)
  end
end
