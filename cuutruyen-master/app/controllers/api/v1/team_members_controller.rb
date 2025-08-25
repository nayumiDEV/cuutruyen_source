# frozen_string_literal: true
class Api::V1::TeamMembersController < ApplicationController
  def index
    team_members = TeamMemberResource.all(params)
    render(jsonapi: team_members)
  end

  def show
    team_member = TeamMemberResource.find(params)
    render(jsonapi: team_member)
  end

  def create
    team_member = TeamMemberResource.build(params)

    if team_member.save
      render(jsonapi: team_member, status: 201)
    else
      render(jsonapi_errors: team_member)
    end
  end

  def update
    team_member = TeamMemberResource.find(params)

    if team_member.update_attributes
      render(jsonapi: team_member)
    else
      render(jsonapi_errors: team_member)
    end
  end

  def destroy
    team_member = TeamMemberResource.find(params)

    if team_member.destroy
      render(jsonapi: { meta: {} }, status: 200)
    else
      render(jsonapi_errors: team_member)
    end
  end
end
