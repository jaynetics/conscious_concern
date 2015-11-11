
require 'spec_helper'

# Test only debug behavior here.
# Test all that's essential to the gem functionality in conscious_concern_spec.

describe ConsciousConcern::EagerLoader do
  context 'in debug mode' do
    before(:all) { ConsciousConcern::EagerLoader.debug = true  }
    after(:all)  { ConsciousConcern::EagerLoader.debug = false }

    describe '#load_classes_in_rails_dir' do
      it 'warns if no rails root is found' do
        without_rails_root do
          expect(STDOUT).to receive(:puts)
          ConsciousConcern::EagerLoader.load_classes_in_rails_dir('models')
        end
      end

      it 'warns if the passed directory isnt found' do
        expect(STDOUT).to receive(:puts)
        ConsciousConcern::EagerLoader.load_classes_in_rails_dir('bad_dir')
      end
    end

    describe '#load_class_at_path' do
      it 'notifies of found classes' do
        expect(STDOUT).to receive(:puts)
        path = Rails.root.join('app', 'models', 'post.rb')
        ConsciousConcern::EagerLoader.load_class_at_path(path)
      end

      it 'warns if requiring a class failed' do
        expect(STDOUT).to receive(:puts)
        ConsciousConcern::EagerLoader.load_class_at_path('bad_path')
      end
    end
  end
end
