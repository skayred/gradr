class CoursesController < ApplicationController
  def index
    @courses = current_user.courses
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find_by_id(params[:id])

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
