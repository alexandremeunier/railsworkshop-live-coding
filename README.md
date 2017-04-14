1. `gem install rails -v 5`
1. `ln -s /usr/local/opt/readline/lib/libreadline.7.0.dylib /usr/local/opt/readline/lib/libreadline.6.dylib`
1. `rails new rails-workshop-live-coding && cd rails-workshop-live-coding`
1. `bin/rails g scaffold Actor name:string rating:integer image_path:string alternative_name:string`
1. `bin/rails db:migrate`
1. `echo "gem 'algoliasearch-rails', '~> 1.19.0'" >> Gemfile`
1. `bundle`
1. `echo "AlgoliaSearch.configuration = { application_id: '', api_key: '' }" > config/initializers/algoliasearch.rb`
1. In `app/models/actor.rb`

    ``` ruby
    include AlgoliaSearch
    algoliasearch do
      attributes :name, :alternative_name
      searchableAttributes [:name, :alternative_name]
      customRanking ['asc(ranking)']
    end
    ```

1. `bin/rails runner "Actor.reindex"`
1. Check Algolia dashboard
1. `bin/rails runner "pp Actor.search('George')"`
1. In `app/views/layouts/application.html.erb`

    ```
      <script src="https://cdn.jsdelivr.net/algoliasearch/3/algoliasearch.min.js"></script>
      <script src="https://cdn.jsdelivr.net/autocomplete.js/0/autocomplete.min.js"></script>

      [...]

      <input type="text" id="search-input" placeholder="Search actors..." />
      <script type="text/javascript">
        var client = algoliasearch('', '')
        var index = client.initIndex('Actor');
        autocomplete('#search-input', { hint: false }, [
          {
            source: autocomplete.sources.hits(index, { hitsPerPage: 5 }),
            displayKey: 'name',
            templates: {
              suggestion: function(suggestion) {
                return suggestion._highlightResult.name.value;
              }
            }
          }
        ]).on('autocomplete:selected', function(event, suggestion, dataset) {
          location.href = '/actors/' + suggestion.objectID
        });
      </script>

      [...]

      <style>
      .algolia-autocomplete {
        width: 100%;
      }
      .algolia-autocomplete .aa-input, .algolia-autocomplete .aa-hint {
        width: 100%;
      }
      .algolia-autocomplete .aa-hint {
        color: #999;
      }
      .algolia-autocomplete .aa-dropdown-menu {
        width: 100%;
        background-color: #fff;
        border: 1px solid #999;
        border-top: none;
      }
      .algolia-autocomplete .aa-dropdown-menu .aa-suggestion {
        cursor: pointer;
        padding: 5px 4px;
      }
      .algolia-autocomplete .aa-dropdown-menu .aa-suggestion.aa-cursor {
        background-color: #B2D7FF;
      }
      .algolia-autocomplete .aa-dropdown-menu .aa-suggestion em {
        font-weight: bold;
        font-style: normal;
      }
      </style>
    ```
1. `bin/rails s`
1. `open localhost:3000/actors`