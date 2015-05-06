class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :customer

      # they can read their own profile
      can :read, Customer do |u|  
        u.id == user.id
      end

      # they can update their own profile
      can :update, Customer do |u|  
        u.id == user.id
      end
      
      # they can read their own orders' data
      can :read, Order do |this_order|  
        my_orders = Customer.find_by(user_id: user.id).orders.map(&:id)
        my_orders.include? this_order.id 
      end

      can :read, Address do |this_address|
        my_addresses = Customer.find_by(user_id: user.id).addresses.map(&:id)
        my_addresses = this_address.id
      end

      can :create, Order
      # they can create new addresses for themselves
      can :create, Address
      can :read, Item

      cannot :new, Item
      # # they can update the project only if they are the manager (creator)
      # can :update, Project do |this_project|
      #   managed_projects = user.projects.map{|p| p.id if p.manager_id == user.id}
      #   managed_projects.include? this_project.id
      # end
            
      # # they can read tasks in these projects
      # can :read, Task do |this_task|  
      #   project_tasks = user.projects.map{|p| p.tasks.map(&:id)}.flatten
      #   project_tasks.include? this_task.id 
      # end
      
      # # they can update tasks in these projects
      # can :update, Task do |this_task|  
      #   project_tasks = user.projects.map{|p| p.tasks.map(&:id)}.flatten
      #   project_tasks.include? this_task.id 
      # end
      
      # # they can create new tasks for these projects
      # can :create, Task do |this_task|  
      #   my_projects = user.projects.map(&:id)
      #   my_projects.include? this_task.project_id  
      # end

    elsif user.role? :baker
      can :read, Item
      can :show, Item
      can :manage, Order

    elsif user.role? :shipper
      can :read, Item
      can :show, Item
      can :manage, Order
      can :manage, OrderItem

    else
      # guests can only browse items and sign up
      can :read, Item
      can :show, Item
      can :new, User
      can :new, Customer
      can :create, User
      can :create, Customer
    end
  end
end