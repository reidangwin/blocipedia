class WikiPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def permitted_attributes
    if !user.standard?
      [:title, :body, :private]
    else
      [:title, :body]
    end
  end

  def index?
    true
  end

  def show?
    scope.where(:id => @wiki.id).exists?
  end

  def create?
    @user.present?
  end

  def new?
    create?
  end

  def update?
    !@wiki.private or @wiki.user == @user or @wiki.collaborators.pluck(:user_id).include?(user.id)
  end

  def edit?
    update?
  end

  def destroy?
    @user.admin? or @wiki.user == user
  end

  def scope
    Pundit.policy_scope!(user, @wiki.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      if user.role == 'admin'
        wikis = scope.all
      elsif user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.user == user || wiki.collaborators.pluck(:user_id).include?(user.id)
            wikis << wiki
          end
        end
      else
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.collaborators.pluck(:user_id).include?(user.id)
            wikis << wiki
          end
        end
      end
      Wiki.where(id: wikis.map(&:id))
    end
  end
end
