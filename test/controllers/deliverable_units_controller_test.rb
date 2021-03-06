require 'test_helper'

class DeliverableUnitsControllerTest < ActionController::TestCase

  setup do
    @request.env['reseller'] = resellers(:reseller_one)
    @deliverable_unit = deliverable_units(:deliverable_unit_one_one)
    sign_in users(:user_one)
    customers(:customer_one).update(enable_orders: false)
  end

  test 'user can only view deliverable units from its customer' do
    ability = Ability.new(users(:user_one))
    assert ability.can? :manage, @deliverable_unit
    ability = Ability.new(users(:user_three))
    assert ability.cannot? :manage, @deliverable_unit

    get :edit, id: deliverable_units(:deliverable_unit_two_one)
    assert_response :redirect
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:deliverable_units)
    assert_valid response
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_valid response
  end

  test 'should create deliverable unit' do
    assert_difference('DeliverableUnit.count') do
      post :create, deliverable_unit: { label: @deliverable_unit.label }
    end

    assert_redirected_to deliverable_units_path
  end

  test 'should not create deliverable unit' do
    assert_no_difference('DeliverableUnit.count') do
      post :create, deliverable_unit: { optimization_overload_multiplier: -1 }
    end

    assert_template :new
    deliverable_unit = assigns(:deliverable_unit)
    assert deliverable_unit.errors.any?
    assert_valid response
  end

  test 'should get edit' do
    get :edit, id: @deliverable_unit
    assert_response :success
    assert_valid response
  end

  test 'should update deliverable unit' do
    patch :update, id: @deliverable_unit, deliverable_unit: { label: @deliverable_unit.label }
    assert_redirected_to deliverable_units_path
  end

  test 'should not update deliverable unit' do
    patch :update, id: @deliverable_unit, deliverable_unit: { optimization_overload_multiplier: -1 }
    assert_template :edit
    deliverable_unit = assigns(:deliverable_unit)
    assert deliverable_unit.errors.any?
    assert_valid response
  end

  test 'should destroy deliverable unit' do
    assert_difference('DeliverableUnit.count', -1) do
      delete :destroy, id: @deliverable_unit
    end

    assert_redirected_to deliverable_units_path
  end

  test 'should destroy multiple deliverable units' do
    assert_difference('DeliverableUnit.count', -2) do
      delete :destroy_multiple, deliverable_units: { deliverable_units(:deliverable_unit_one_one).id => 1, deliverable_units(:deliverable_unit_one_two).id => 1 }
    end

    assert_redirected_to deliverable_units_path
  end
end
