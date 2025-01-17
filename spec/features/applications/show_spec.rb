require 'rails_helper'

RSpec.describe 'application show page' do
  it "shows the application and all it's attributes" do
    murph = Application.create!(name: "Murph", street_address: "456 Acres Ln", city: "Boca Rotan", state: "FL", zip_code: "33481", description: "Jack would have a brother", status: "In Progress")
    cyle = Application.create!(name: "Cyle", street_address: "139 Corvette St", city: "Inman", state: "SC", zip_code: "29349", description: "I would take him disc'n", status: "In Progress")
    
    visit "/applications/#{murph.id}"

    expect(page).to have_content(murph.name)
    expect(page).to have_content(murph.street_address)
    expect(page).to have_content("In Progress")
    expect(page).to_not have_content(cyle.name)
  end

  it "search by Pet's name" do
    murph = Application.create!(name: "Murph", street_address: "456 Acres Ln", city: "Boca Rotan", state: "FL", zip_code: "33481", description: "Jack would have a brother", status: "In Progress")
    cyle = Application.create!(name: "Cyle", street_address: "139 Corvette St", city: "Inman", state: "SC", zip_code: "29349", description: "I would take him disc'n", status: "In Progress")
    homing_homies = Shelter.create!(name: "Homing Homies", city: "Houston", rank: 1, foster_program: true)
    hank = homing_homies.pets.create!(name: "Hank", breed: "Aussie", adoptable: true, age: 6)
    happy = homing_homies.pets.create!(name: "Happy", breed: "Pit Bull", adoptable: true, age: 1)
    honus = homing_homies.pets.create!(name: "Honus", breed: "Blood Hound", adoptable: false, age: 2)

    visit "/applications/#{murph.id}"

    fill_in :search_name, with: "Happy"

    click_button 'Search'
    
    expect(current_path).to eq("/applications/#{murph.id}")

    expect(page).to have_content(happy.name)
  end

  it 'can adopt a pet' do
    murph = Application.create!(name: "Murph", street_address: "456 Acres Ln", city: "Boca Rotan", state: "FL", zip_code: "33481", description: "Jack would have a brother", status: "In Progress")
    cyle = Application.create!(name: "Cyle", street_address: "139 Corvette St", city: "Inman", state: "SC", zip_code: "29349", description: "I would take him disc'n", status: "In Progress")
    homing_homies = Shelter.create!(name: "Homing Homies", city: "Houston", rank: 1, foster_program: true)
    hank = homing_homies.pets.create!(name: "Hank", breed: "Aussie", adoptable: true, age: 6)
    happy = homing_homies.pets.create!(name: "Happy", breed: "Pit Bull", adoptable: true, age: 1)
    honus = homing_homies.pets.create!(name: "Honus", breed: "Blood Hound", adoptable: false, age: 2)

    visit "/applications/#{murph.id}"

    fill_in :search_name, with: "Happy"

    click_button 'Search'

    click_button 'Adopt this Pet'

    expect(current_path).to eq("/applications/#{murph.id}")
    expect(page).to have_content("Happy")
  end

  it 'inputs description and submits an application' do
    murph = Application.create!(name: "Murph", street_address: "456 Acres Ln", city: "Boca Rotan", state: "FL", zip_code: "33481", description: "Jack would have a brother", status: "In Progress")
    cyle = Application.create!(name: "Cyle", street_address: "139 Corvette St", city: "Inman", state: "SC", zip_code: "29349", description: "I would take him disc'n", status: "In Progress")
    homing_homies = Shelter.create!(name: "Homing Homies", city: "Houston", rank: 1, foster_program: true)
    hank = homing_homies.pets.create!(name: "Hank", breed: "Aussie", adoptable: true, age: 6)
    happy = homing_homies.pets.create!(name: "Happy", breed: "Pit Bull", adoptable: true, age: 1)
    honus = homing_homies.pets.create!(name: "Honus", breed: "Blood Hound", adoptable: false, age: 2)

    visit "/applications/#{murph.id}"
    
    fill_in :search_name, with: "hAppY"
    click_button "Search"
    expect(page).to have_content(happy.name)
    click_button 'Adopt this Pet'

    fill_in :search_name, with: "ho"
    click_button "Search"
    expect(page).to have_content(honus.name)
    click_button 'Adopt this Pet'

    expect(page).to_not have_content(hank.name)
    expect(page).to have_content("Description")
    fill_in :description, with: "I like dogs"
    click_button "Submit"

    expect(current_path).to eq("/applications/#{murph.id}")
    expect(page).to have_content("Pending")
    expect(page).to have_content(happy.name)
    expect(page).to have_content(honus.name)
  end

  it 'will not submit with no pets' do
    murph = Application.create!(name: "Murph", street_address: "456 Acres Ln", city: "Boca Rotan", state: "FL", zip_code: "33481", description: "Jack would have a brother", status: "In Progress")
    cyle = Application.create!(name: "Cyle", street_address: "139 Corvette St", city: "Inman", state: "SC", zip_code: "29349", description: "I would take him disc'n", status: "In Progress")
    homing_homies = Shelter.create!(name: "Homing Homies", city: "Houston", rank: 1, foster_program: true)
    hank = homing_homies.pets.create!(name: "Hank", breed: "Aussie", adoptable: true, age: 6)
    happy = homing_homies.pets.create!(name: "Happy", breed: "Pit Bull", adoptable: true, age: 1)
    honus = homing_homies.pets.create!(name: "Honus", breed: "Blood Hound", adoptable: false, age: 2)

    visit "/applications/#{murph.id}"

    expect(page).to_not have_content("Submit")
  end

  it 'returns partial search matches' do
    murph = Application.create!(name: "Murph", street_address: "456 Acres Ln", city: "Boca Rotan", state: "FL", zip_code: "33481", description: "Jack would have a brother", status: "In Progress")
    cyle = Application.create!(name: "Cyle", street_address: "139 Corvette St", city: "Inman", state: "SC", zip_code: "29349", description: "I would take him disc'n", status: "In Progress")
    homing_homies = Shelter.create!(name: "Homing Homies", city: "Houston", rank: 1, foster_program: true)
    hank = homing_homies.pets.create!(name: "Hank", breed: "Aussie", adoptable: true, age: 6)
    happy = homing_homies.pets.create!(name: "Happy", breed: "Pit Bull", adoptable: true, age: 1)
    honus = homing_homies.pets.create!(name: "Honus", breed: "Blood Hound", adoptable: false, age: 2)

    visit "/applications/#{murph.id}"

    fill_in :search_name, with: "Ha"
    click_button "Search"
    expect(page).to have_content(happy.name)
    expect(page).to have_content(happy.name)
    expect(page).to_not have_content(honus.name)
  end

  it 'returns matches regardless of case' do
    murph = Application.create!(name: "Murph", street_address: "456 Acres Ln", city: "Boca Rotan", state: "FL", zip_code: "33481", description: "Jack would have a brother", status: "In Progress")
    cyle = Application.create!(name: "Cyle", street_address: "139 Corvette St", city: "Inman", state: "SC", zip_code: "29349", description: "I would take him disc'n", status: "In Progress")
    homing_homies = Shelter.create!(name: "Homing Homies", city: "Houston", rank: 1, foster_program: true)
    hank = homing_homies.pets.create!(name: "Hank", breed: "Aussie", adoptable: true, age: 6)
    happy = homing_homies.pets.create!(name: "Happy", breed: "Pit Bull", adoptable: true, age: 1)
    honus = homing_homies.pets.create!(name: "Honus", breed: "Blood Hound", adoptable: false, age: 2)

    visit "/applications/#{murph.id}"

    fill_in :search_name, with: "hApPy"
    click_button "Search"
    expect(page).to have_content(happy.name)
  end
end


# And I do not see a section to add more pets to this application