class WeightsController < ApplicationController
  def create
    weight = Weight.new weight_params
    weight.assignment_id = params[:assignment_id]
    weight.save!

    redirect_back(fallback_location: root_path)
  end

  def update
    weight = Weight.find_by_id(params[:id])
    weight.attributes = weight_params
    weight.save!

    redirect_back(fallback_location: root_path)
  end

  def destroy
    Weight.find_by_id(params[:id]).destroy

    redirect_back(fallback_location: root_path)
  end

  def weight_params
    params.require(:weight).permit(:name, :weight)
  end
end
