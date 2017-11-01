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
    !@wiki.private or @wiki.user == @user


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
      scope
    end
  end
end
