resource "Books" do
  serializer do
    desc "A unique id for the book", :type => :integer
    attribute :id

    desc "The title of the book", :type => :string
    attribute :title

    desc "The author of the book"
    has_one :author

    desc "Documentation for computed property"
    def computed_property
      object.created_at
    end
  end

  # This will create a class 'UpdateBook'.  The execute method
  # is open for definition by the developer.
  command :update, "Update a book's attributes" do
    # Will ensure the command is run with
    # Book.accessible_to(current_user).find(id).
    scope :accessible_to

    params do
      duck :id, :method => :to_s

      optional do
        string :title
      end
    end
  end

  command :create, "Add a new book to the library" do
    scope :accessible_to

    params do
      string :title
    end
  end

  command :like, 'Toggle liking on/off for a book' do
    scope :all

    params do
      duck :id, :method => :to_s

      optional do
        desc "You can manually pass true or false.  If you leave it off, it will toggle the liking status"
        boolean :like, :discard_empty => true
      end
    end
  end

  # This will create a class 'BookQuery'.  The build_scope method
  # is open for definition by the developer.
  query do
    start_from :scope => :accessible_to

    params do
      desc "The year the book was published (example: YYYY)"
      integer :year_published
    end

    role :admin do
      start_from :scope => :all
    end
  end

  # Each resource will be mounted by the API under a base path
  # such as /api/v1.  So the routes defined here would be available
  # under /api/v1/books, /api/v1/books/1 etc
  routes do
    desc "List all books"
    get "/books", :to => :query

    desc "Show an individual book"
    show "/books/:id", :to => :show

    desc "Create a new book"
    post "/books", :to => :create

    desc "Update an existing book"
    put "/books/:id", :to => :update

    desc "Like a book"
    put "/books/:id/like", :to => :like
  end

  examples :client => :rest do
    setup_data do
      let(:books) do
        3.times.map { |n| create(:book, title: "Book #{ n }") }
      end
    end

    with_profile :public_user do
      example "Listing all of the books", :route => :query
      example "Viewing a single book", :route => :show
    end
  end

end
