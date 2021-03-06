class BoardsController < ApplicationController
  before_filter :auth, :except => [:index, :show]
  # GET /boards
  # GET /boards.xml
  def index
    @allboards = Board.all
	current_user = UserSession.find
	user_id = current_user && current_user.record.id
	@myboards = Board.find(:all, :conditions => {:user_id => user_id})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @boards }
    end
  end

  # GET /boards/1
  # GET /boards/1.xml
  def show
    @board = Board.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/new
  # GET /boards/new.xml
  def new
    @board = Board.new
	@professors = Professor.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
  end

  # POST /boards
  # POST /boards.xml
  def create
    @board = Board.new(params[:board])
	@board.generated = DateTime.now
	current_user = UserSession.find
	@board.user_id = current_user and current_user.record.id
	phrases = Array.new
	@items = Phrase.random(25, :conditions => {:professor_id => @board.professor})
	@items.sort_by{rand}.each do |phrase|
		phrases.push(phrase)
	end
	@board.phrases = phrases
    respond_to do |format|
      if @board.save
        flash[:notice] = 'Board was successfully created.'
        format.html { redirect_to(@board) }
        format.xml  { render :xml => @board, :status => :created, :location => @board }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.xml
  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        flash[:notice] = 'Board was successfully updated.'
        format.html { redirect_to(@board) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.xml
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to(boards_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def auth
    if not UserSession.find
	  redirect_to :controller => 'user_sessions', :action => 'new'
	end
  end
end
