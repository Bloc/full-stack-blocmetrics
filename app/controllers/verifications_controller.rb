class VerificationsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @domain = current_user.domains.find(params[:domain_id])

    doc = HTTParty.get(@domain.url).parsed_response

    html = Nokogiri::HTML(doc)

    verification = html.xpath("//meta[@name='blocmetrics_verification']")

    if verification.present? && verification.first["content"] == @domain.verification_code
      @domain.update_attribute(:verified, true)
      redirect_to dashboard_domain_url(@domain), notice: "Domain successfully verified"
    else
      redirect_to dashboard_domain_url(@domain), notice: "Could not find the verification code in #{@domain.url}"
    end
  end
end
