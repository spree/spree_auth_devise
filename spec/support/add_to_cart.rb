def add_to_cart(product)
  visit spree.product_path(product)

  if Spree.version.to_f > 3.6
    expect(page).to have_selector('form#add-to-cart-form')
    expect(page).to have_selector('button#add-to-cart-button')
    wait_for_condition do
      expect(page.find('#add-to-cart-button').disabled?).to eq(false)
    end
  end
  click_button 'Add To Cart'
  wait_for_condition do
    expect(page).to have_content(Spree.t(:added_to_cart))
  end

  if block_given?
    yield
  else
    click_link 'View cart'
    expect(page).to have_content 'YOUR SHOPPING BAG'
  end
end
