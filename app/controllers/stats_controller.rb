class StatsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def username
    member_id = User.find_by_username(params[:username]).try(:member_id)
    if member_id
      redirect_to "/stats/member/#{member_id}"
    else
      flash[:notice] = "No users with username #{params[:username]} is registered"
      redirect_to '/register'
    end
  end

  def show
    @member = User.find_by_member_id(params[:member_id])
    if @member
      @claims = Claim.where(member_id: @member.member_id).order(sort_column + " " + sort_direction)
      @claims.map do |claim|
        case claim.transaction_status
        when 'tesSUCCESS'
          claim.transaction_status = 'success'
        when 'submitted'
        else 
          claim.transaction_status = 'failed'
        end
      end
    else
      flash[:notice] = "No member has registered with id #{params[:member_id]}"
      redirect_to '/'
    end
  end

  private

  def sort_column
    Claim.column_names.include?(params[:sort_col]) ? params[:sort_col] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_dir]) ? params[:sort_dir] : "desc"
  end
end
