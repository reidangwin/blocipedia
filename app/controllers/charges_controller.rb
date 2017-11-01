class ChargesController < ApplicationController
  def create
    # Creates a Stripe Customer object, for associating
    # with the charge

    customer = Stripe::Customer.create(
        email: current_user.email,
        card: params[:stripeToken]
    )

    # Where the real magic happens
    charge = Stripe::Charge.create(
        customer: customer.id, # Note -- this is NOT the user_id in your app
        amount: amount_default,
        description: "BigMoney Membership - #{current_user.email}",
        currency: 'usd'
    )

    if charge['paid'] == true
      current_user.upgrade
    end

    flash[:notice] = "Thanks for your payment, #{current_user.email}! Your account has been upgraded to Premium."
    redirect_to root_path # or wherever

      # Stripe will send back CardErrors, with friendly messages
      # when something goes wrong.
      # This `rescue block` catches and displays those errors.
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_charge_path
  end

  def new
    @stripe_btn_data = {
        key: "#{ Rails.configuration.stripe[:publishable_key] }",
        description: "BigMoney Membership - #{current_user.email}",
        amount: amount_default
    }
  end

  def downgrade
    current_user.update_attribute(:role, :standard)
    current_user.wikis.where(private: true).update_all(private: false)
    flash[:notice] = "Your account has been downgraded to standard. All of your private wikis have been made public."
    redirect_to root_path
  end

  private

  def amount_default
    15_00
  end

end

