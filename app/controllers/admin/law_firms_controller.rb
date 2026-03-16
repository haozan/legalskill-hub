module Admin
  class LawFirmsController < BaseController
    before_action :set_law_firm, only: [:show, :edit, :update, :destroy]

    def index
      @law_firms = LawFirm.order(:name)
      if params[:q].present?
        @law_firms = @law_firms.where("name LIKE ?", "%#{params[:q]}%")
      end
      @law_firms = @law_firms.page(params[:page]).per(20)
    end

    def new
      @law_firm = LawFirm.new
    end

    def create
      @law_firm = LawFirm.new(law_firm_params)
      if @law_firm.save
        redirect_to admin_law_firms_path, notice: "律所「#{@law_firm.name}」已创建"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @law_firm.update(law_firm_params)
        redirect_to admin_law_firms_path, notice: "律所「#{@law_firm.name}」已更新"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @law_firm.destroy
      redirect_to admin_law_firms_path, notice: "律所已删除"
    end

    private

    def set_law_firm
      @law_firm = LawFirm.find(params[:id])
    end

    def law_firm_params
      params.require(:law_firm).permit(:name, :province, :city, :district)
    end
  end
end
