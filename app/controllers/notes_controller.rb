class NotesController < MainController
  before_action :find_note!, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  before_action -> { assign_sender_to_model(:note) }, only: [:create, :update]

  def index
    @notes = current_user.notes.order(created_at: :desc)
  end

  def show; end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new note_params
    if @note.save
      respond_to do |f|
        f.turbo_stream { flash.now[:success] = "успешно создано" }
      end
    else
      render :new
    end
  end

  def edit; end

  def update
    if @note.update note_params
      respond_to do |f|
        f.turbo_stream { flash.now[:success] = "успешно обновлено" }
      end
    else
      render :edit
    end
  end

  def destroy
    @note.destroy
    respond_to do |f|
      f.turbo_stream { flash.now[:success] = "успешно удалено" }
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :description, :user_id)
  end

  def find_note!
    @note = Note.find(params[:id])
  end
end
