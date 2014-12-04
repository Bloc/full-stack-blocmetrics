class DomainsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @domain = current_user.domains.build
  end

  def create
    @domain = current_user.domains.build(domain_params)
    if @domain.save
      redirect_to dashboard_domain_url(@domain), notice: "Domain created. Please follow the instructions below to verify it."
    else
      render :new
    end
  end

  def show
    @domain = current_user.domains.find(params[:id])
    @events = @domain.events.desc(:created_at)

    data_table = GoogleVisualr::DataTable.new

    data_table.new_column('string', 'Date' )
    data_table.new_column('number', 'Events')

    rows = []

    @events.group_by {|event| event.created_at.strftime("%d/%m/%Y") }.each_pair do |date, events|
      rows << [date, events.count]
    end

    data_table.add_rows(rows)

    option = { height: 280, title: 'Events by date' }
    @chart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)
  end

  def edit
    @domain = current_user.domains.find(params[:id])
  end

  def update
    @domain = current_user.domains.find(params[:id])
    if @domain.update_attributes(domain_params)
      redirect_to dashboard_domain_url(@domain), notice: "Domain updated."
    else
      render :edit
    end
  end

  def destroy
    @domain = current_user.domains.find(params[:id])
    @domain.destroy
    redirect_to dashboard_url, notice: "Domain deleted."
  end

  private

  def domain_params
    params.require(:domain).permit(:name, :url)
  end

end
