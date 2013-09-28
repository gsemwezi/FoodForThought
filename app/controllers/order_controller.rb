class OrderController < ApplicationController

  def new
    @order = Order.new
    @items = Item.where(available: true)
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new params.require(:order).permit(:name)

    @items = Item.find(params[:items])
    @order.items = @items
    @order.save

    redirect_to @order
  end
end