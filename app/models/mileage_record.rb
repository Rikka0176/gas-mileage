class MileageRecord < ApplicationRecord
    belongs_to :car
    validates :distance, numericality: { greater_than: 0 }
    validates :fuel_amount, numericality: { greater_than: 0 }
  end

  def new_mileage
    @car = Car.find(params[:id])
    @mileage_record = @car.mileage_records.build
  end

  def create_mileage
    @car = Car.find(params[:id])
    @mileage_record = @car.mileage_records.build(mileage_params)
  
    if @mileage_record.save
      flash[:success] = "Mileage record saved successfully."
      redirect_to @car
    else
      render 'new_mileage'
    end
  end

  def show
    @car = Car.find_by(id: params[:id])
    return redirect_to cars_path, alert: "Car not found." if @car.nil?
  
    @mileage_records = @car.mileage_records
  end
end