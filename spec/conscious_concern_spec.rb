
require 'spec_helper'

describe ConsciousConcern do
  before(:all) { ConsciousConcern.load_classes }

  describe '::load_classes' do
    it 'eager loads all controller classes from the standard rails dir' do
      expect(descendant_count_of(ApplicationController)).to be >= 2
    end

    it 'eager loads all model classes from the standard rails dir' do
      expect(descendant_count_of(ActiveRecord::Base)).to be >= 2
    end

    it 'can take arguments to load classes from custom directories' do
      custom_dir_a = Rails.root.join('app', 'custom_model_dir_a')
      custom_dir_b = Rails.root.join('app', 'custom_model_dir_b')
      expect { ConsciousConcern.load_classes(custom_dir_a, custom_dir_b) }
        .to change { descendant_count_of(ActiveRecord::Base) }
        .by(2)
    end

    it 'finds classes recursively / in nested directories' do
      nested_dir = Rails.root.join('app', 'deeply_nested_model_dir')
      expect { ConsciousConcern.load_classes(nested_dir) }
        .to change { descendant_count_of(ActiveRecord::Base) }
        .by(1)
    end

    it 'doesnt fail if no rails root is found' do
      without_rails_root do
        expect { ConsciousConcern.load_classes }
          .not_to raise_error
      end
    end

    it 'doesnt fail if a passed directory isnt found' do
      expect { ConsciousConcern.load_classes('inexistent_dir') }
        .not_to raise_error
    end
  end

  describe '::extenders' do
    it 'lists all modules that extend ConsciousConcern' do
      expect(ConsciousConcern.extenders.sort_by(&:to_s))
        .to eq([Likable, Liking, PostsGenerating])
    end
  end

  describe '#controllers' do
    it 'lists all controllers that use a controller concern' do
      expect(PostsGenerating.controllers)
        .to eq([PostsController])
    end

    it 'lists all controllers that are associated with a model concern' do
      expect(Likable.controllers.sort_by(&:to_s))
        .to eq([CommentsController, PostsController])
    end
  end

  describe '#models' do
    it 'lists all models that use a model concern' do
      expect(Likable.models.sort_by(&:to_s)).to eq([Comment, Post])
    end

    it 'lists all models that are associated with a controller concern' do
      expect(PostsGenerating.models).to eq([Post])
    end
  end

  describe '#tables' do
    it 'lists all tables that are associated with a model concern' do
      expect(Likable.tables.sort).to eq(%w(comments posts))
    end

    it 'lists all tables that are associated with a controller concern' do
      expect(PostsGenerating.tables).to eq(%w(posts))
    end
  end

  describe '#resources' do
    it 'adds routes for all models that use this concern' do
      Rails.application.routes.draw do
        Likable.resources do
          member do
            post 'unlike'
          end
        end
      end
      routes = Rails.application.routes.routes.map(&:defaults)
      expect(routes).to include(controller: 'comments', action: 'unlike')
      expect(routes).to include(controller: 'posts',    action: 'unlike')
    end
  end

  describe '#let_controllers' do
    it 'modifies all controllers associated with this concern' do
      Likable.class_eval { let_controllers(include: Liking) }

      # trigger callbacks
      ConsciousConcern.load_classes

      expect(Liking.controllers.sort_by(&:to_s))
        .to eq([CommentsController, PostsController])
    end
  end
end
