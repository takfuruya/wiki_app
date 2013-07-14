class NotesController < ApplicationController
  before_filter :signed_in_user, only: [:create, :update, :destroy]

  def index
  end

  def show
    @note = Note.find(params[:id])
  end

  def create
    @note = current_user.notes.build
    @note.name = "Untitled"
    @note.content = "Type here."
    if @note.save
      flash[:success] = "Note created!"
      redirect_to edit_note_path(@note)
    else
      render 'static_pages/home'
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    @note.content = params[:content]

    if @note.save
      render text: @note.content
    else
      # Failed to update note.
      flash[:error] = @note.errors.full_messages[0]
      redirect_to edit_note_path(@note)
    end
  end

  def destroy
    Note.find(params[:id]).destroy
    flash[:success] = "Page destroyed."
    redirect_to root_path
  end
end