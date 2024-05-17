class CarsController < ApplicationController
  # 車の一覧を表示するアクション
  def index
    @cars = Car.all
  end

  # 新しい車を作成するフォームを表示するアクション
  def new
    @car = Car.new
  end

  # 新しい車を作成するアクション
  def create
    @car = Car.new(car_params)
    if @car.save
      redirect_to cars_path, notice: "Car was successfully created."
    else
      render :new
    end
  end

  # 新しい燃費情報の入力フォームを表示するアクション
  def new_mileage
    @car = Car.find(params[:id])
    @mileage_record = MileageRecord.new
  end

  # フォームから送信された燃費情報を処理するアクション
  def create_mileage
    @car = Car.find(params[:id])
    @mileage_record = MileageRecord.new(mileage_params)
    @mileage_record.car = @car

    # 送信されたデータが正しいかどうかを確認
    if mileage_data_valid?
      # 燃費を計算する
      if @mileage_record.save
        # 燃費の計算（例：1リットルあたりの走行距離）
        fuel_efficiency = @mileage_record.distance / @mileage_record.fuel_amount
        # ガソリン1リットルで何キロメートル走るかを表示
        @fuel_efficiency_kmpl = fuel_efficiency.round(2) # ガソリン1リットルで何キロメートル走るか
        # フラッシュメッセージを表示
        flash[:success] = "Mileage record saved successfully."
        redirect_to @car
      else
        render 'new_mileage'
      end
    else
      flash.now[:alert] = "Invalid mileage data. Please make sure both distance and fuel amount are provided and fuel amount is not zero."
      render 'new_mileage'
    end
  end

  # 車の詳細を表示するアクション
  def show
    @car = Car.find_by(id: params[:id])
    if @car.nil?
      logger.error "Car not found with ID: #{params[:id]}"
      flash[:alert] = "Car not found."
      redirect_to cars_path
    end
  end

  # 登録された車の情報を削除する
  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    redirect_to cars_url, notice: "Car was successfully destroyed."
  end

  private

  # Strong Parametersを使用してフォームから送信された車のデータをフィルタリング
  def car_params
    params.require(:car).permit(:make, :model, :year, :mileage)
  end

  # Strong Parametersを使用してフォームから送信された燃費情報のデータをフィルタリング
  def mileage_params
    params.require(:mileage_record).permit(:distance, :fuel_amount)
  end

  # 送信された燃費データが有効かどうかを確認
  def mileage_data_valid?
    @mileage_record.distance.present? && @mileage_record.fuel_amount.present? &&
    @mileage_record.distance > 0 && @mileage_record.fuel_amount > 0
  end
end