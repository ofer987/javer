require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  test 'photo should not belong to user = nil' do
    photo = new_valid_photo

    photo.user_id = nil
    assert !photo.valid?, 'photo.user_id should not be nil'
  end

  test 'photo should not belong to an unknown user' do
    photo = new_valid_photo

    photo.user_id = 4332
    assert !photo.valid?, 'photo should belong to an existing user'
  end

  test 'photo should have a filename' do
    photo = new_valid_photo

    photo.filename = nil
    assert !photo.valid?, 'photo.filename should not be nil'
  end

  test 'photo should have a valid filename' do
    photo = new_valid_photo
    
    assert photo.valid?, "Filename: '#{photo.filename}' should be valid"

    photo.filename = 'beauitful_photo.jpg'
    assert photo.valid?, "Filename: '#{photo.filename}' should be valid"

    photo.filename = 'beauitful_photo.JPG'
    assert photo.valid?, "Filename: '#{photo.filename}' should be valid"

    photo.filename = 'beauitful_photo.jpG'
    assert photo.valid?, "Filename: '#{photo.filename}' should be valid"

    # Invalid filenames
    photo.filename = 'beauitful_photo.gif'
    assert !photo.valid?, "Filename: '#{photo.filename}' should not be valid"

    photo.filename = '.gifbeauitful_photo.gif'
    assert !photo.valid?, "Filename: '#{photo.filename}' should not be valid"

    photo.filename = '.gif.beauitful_photo.gif'
    assert !photo.valid?, "Filename: '#{photo.filename}' should not be valid"

    photo.filename = 'beauitful_photo.bak.jpg'
    assert !photo.valid?, "Filename: '#{photo.filename}' should not be valid"
  end

  private
    def new_valid_photo
      Photo.new do |photo|
        photo.title = "New Title"
        photo.description = 'New Description'
        photo.filename = 'new.jpg'
        photo.taken_at = DateTime.current # UTC
        photo.user = users(:dan)
      end
    end
end
