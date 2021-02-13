note
	description: "Main window for this application."
	author: "Generated by the Vision Application Wizard."
	date: "$Date: 2021/1/29 9:52:5 $"
	revision: "1.0.1"

class
	MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects,
			initialize,
			is_in_default_state
		end

	INTERFACE_NAMES
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
		local

			ff: ELLIPSE_FACTORY -- EG_SIMPLE_FACTORY
			-- <Precursor>
		do
				-- Create main container.
			create scm_cell
			create main_container
				-- Create the menu bar.
			create standard_menu_bar
				-- Create file menu.
			create file_menu.make_with_text (Menu_file_item)
				-- Create help menu.
			create help_menu.make_with_text (Menu_help_item)

				-- Create a toolbar.
			create standard_toolbar

				-- Create a status bar and a status label.
			create standard_status_bar
			create standard_status_label.make_with_text ("Add your status text here...")

			create ff
			create tree_service.make
			create world.make_with_model_and_factory (tree_service.graph, ff)
			create model_cell.make_with_world (world)
			create tree_layout.make_with_world_and_root (world, tree_service.root)
		end

	initialize
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}

				-- Create and add the menu bar.
			build_standard_menu_bar
			set_menu_bar (standard_menu_bar)

				-- Create and add the toolbar.
			build_standard_toolbar
			main_container.extend (create {EV_HORIZONTAL_SEPARATOR})
			main_container.disable_item_expand (main_container.first)
			main_container.extend (standard_toolbar)
			main_container.disable_item_expand (standard_toolbar)

			build_main_container
			extend (main_container)

				-- Create and add the status bar.
			build_standard_status_bar
			main_container.extend (standard_status_bar)
			main_container.disable_item_expand (standard_status_bar)

				-- Execute `request_close_window' when the user clicks
				-- on the cross in the title bar.
			close_request_actions.extend (agent request_close_window)

				-- Set the title of the window.
			set_title (Window_title)

				-- Set the initial size of the window.
			set_size (Window_width, Window_height)

			show_actions.extend_kamikaze (agent on_shown)
		end

	on_shown
		local
			t: EV_TIMEOUT
		do
			t := update_status_timeout
			if t = Void then
				create t
				t.actions.extend (agent
					do
						if attached standard_status_label as lab then
							lab.set_text ("WxH=" + model_cell.drawing_area.width.out + "x" + model_cell.drawing_area.height.out)
							lab.refresh_now
						end
					end
				)
				t.set_interval (100)
				update_status_timeout := t
			end
		end

	update_status_timeout: detachable EV_TIMEOUT

	is_in_default_state: BOOLEAN
			-- Is the window in its default state?
			-- (as stated in `initialize')
		do
			Result := (width = Window_width) and then
				(height = Window_height) and then
				(title.is_equal (Window_title))
		end

feature {NONE} -- Menu Implementation

	standard_menu_bar: EV_MENU_BAR
			-- Standard menu bar for this window.

	file_menu: EV_MENU
			-- "File" menu for this window (contains New, Open, Close, Exit...)

	help_menu: EV_MENU
			-- "Help" menu for this window (contains About...)

	build_standard_menu_bar
			-- Create and populate `standard_menu_bar'.
		do
				-- Add the "File" menu.
			build_file_menu
			standard_menu_bar.extend (file_menu)
				-- Add the "Help" menu.
			build_help_menu
			standard_menu_bar.extend (help_menu)
		ensure
			menu_bar_initialized: not standard_menu_bar.is_empty
		end

	build_file_menu
			-- Create and populate `file_menu'.
		local
			menu_item: EV_MENU_ITEM
		do
			create menu_item.make_with_text (Menu_file_new_item)
				--| TODO: Add the action associated with "New" here.
			file_menu.extend (menu_item)

			create menu_item.make_with_text (Menu_file_open_item)
				--| TODO: Add the action associated with "Open" here.
			file_menu.extend (menu_item)

			create menu_item.make_with_text (Menu_file_save_item)
				--| TODO: Add the action associated with "Save" here.
			file_menu.extend (menu_item)

			create menu_item.make_with_text (Menu_file_saveas_item)
				--| TODO: Add the action associated with "Save As..." here.
			file_menu.extend (menu_item)

			create menu_item.make_with_text (Menu_file_close_item)
				--| TODO: Add the action associated with "Close" here.
			file_menu.extend (menu_item)

			file_menu.extend (create {EV_MENU_SEPARATOR})

				-- Create the File/Exit menu item and make it call
				-- `request_close_window' when it is selected.
			create menu_item.make_with_text (Menu_file_exit_item)
			menu_item.select_actions.extend (agent request_close_window)
			file_menu.extend (menu_item)
		ensure
			file_menu_initialized: not file_menu.is_empty
		end

	build_help_menu
			-- Create and populate `help_menu'.
		local
			menu_item: EV_MENU_ITEM
		do
			create menu_item.make_with_text (Menu_help_contents_item)
				--| TODO: Add the action associated with "Contents and Index" here.
			help_menu.extend (menu_item)
		ensure
			help_menu_initialized: not help_menu.is_empty
		end

feature {NONE} -- ToolBar Implementation

	standard_toolbar: EV_TOOL_BAR
			-- Standard toolbar for this window.

	build_standard_toolbar
			-- Populate the standard toolbar.
		local
			but: like new_toolbar_item
			act: like new_toolbar_item
			next: like new_toolbar_item
			run: like new_toolbar_item
		do

			but := new_toolbar_item ("New TREE", "new.png")
			but.set_text ("Tree")
			standard_toolbar.extend (but)
			but.select_actions.extend (agent on_new_tree)

			act := new_toolbar_item ("Add 2 Nodes", "new.png")
			act.set_text ("Add 2 Nodes")
			standard_toolbar.extend (act)
			act.select_actions.extend (agent tree_service.add_random_nodes (2))
			act.select_actions.extend (agent update_layout)

			next := new_toolbar_item ("Next step", "new.png")
			next.set_text ("Next step")
			standard_toolbar.extend (next)
			next.select_actions.extend (agent on_next)
				--			next.select_actions.extend_kamikaze (agent tree_service.dfs)

			run := new_toolbar_item ("Run", "new.png")
			run.set_text ("Run")
			standard_toolbar.extend (run)
				--			next.select_actions.extend (agent tree_service.add_random_nodes(2))
				--			next.select_actions.extend (agent update_layout)

		ensure
			toolbar_initialized: not standard_toolbar.is_empty
		end

	new_toolbar_item (name: READABLE_STRING_GENERAL; image: detachable READABLE_STRING_GENERAL): EV_TOOL_BAR_BUTTON
			-- A new toolbar item with an image from a file `image' or with a text `name' if image is not available.
		local
			toolbar_pixmap: EV_PIXMAP
			fn: PATH
		do
			if attached Result then
					-- Image could not be loaded.
					-- Use a text label instead.
				Result.set_text (name)
			else
					-- The first attempt to create a button from an image file.
				create Result
				if image /= Void then
					create toolbar_pixmap
					create fn.make_from_string ("res")
					toolbar_pixmap.set_with_named_file (fn.extended (image).name)
						-- Make sure the image is effectively loaded by computing its dimention.
					toolbar_pixmap.height.do_nothing
						-- Everything is OK, associate image with the button.
					Result.set_pixmap (toolbar_pixmap)
				end
			end
		rescue
			if attached Result then
					-- Image could not be loaded.
					-- Create a button by setting a label text instead.
				retry
			end
		end

feature {NONE} -- StatusBar Implementation

	standard_status_bar: EV_STATUS_BAR
			-- Standard status bar for this window

	standard_status_label: EV_LABEL
			-- Label situated in the standard status bar.
			--
			-- Note: Call `standard_status_label.set_text (...)' to change the text
			--       displayed in the status bar.

	build_standard_status_bar
			-- Populate the standard toolbar.
		do
				-- Initialize the status bar.
			standard_status_bar.set_border_width (2)

				-- Populate the status bar.
			standard_status_label.align_text_left
			standard_status_bar.extend (standard_status_label)
		end

feature {NONE} -- Implementation, Close event

	request_close_window
			-- Process user request to close the window.
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text (Label_confirm_close_window)
			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button ~ (create {EV_DIALOG_CONSTANTS}).ev_ok then
					-- Destroy the window.
				destroy

					-- End the application.
					--| TODO: Remove next instruction if you don't want the application
					--|       to end when the first window is closed..
				if attached (create {EV_ENVIRONMENT}).application as a then
					a.destroy
				end
			end
		end

feature {NONE} -- Implementation

	main_container: EV_VERTICAL_BOX
			-- Main container (contains all widgets displayed in this window).

	scm_cell: EV_CELL

	build_main_container
			-- Populate `main_container'.
		do
			create scm_cell
			main_container.extend (scm_cell)
			on_new_tree
			scm_cell.replace (model_cell)
		ensure
			main_container_created: main_container /= Void
		end

feature -- Event

	update_layout
		local
			lay: EG_LAYOUT
		do
			tree_layout.set_point_position (0, 0)

			lay := tree_layout
			lay.layout

			ev_application.add_idle_action_kamikaze (agent lay.layout)

			model_cell.disable_scrollbars
			model_cell.crop
		end

	on_new_tree
		local
			root: EG_NODE
		do
			root := tree_service.new_world_tree
			create tree_layout.make_with_world_and_root (world, root)
			update_layout
		end

	on_next
		do
			if attached tree_service.next_on_dfs as node then
				if attached {ELLIPSE_NODE} world.figure_from_model (node) as fig then
					fig.set_color (create {EV_COLOR}.make_with_rgb (.1, .1, .1))
					print (fig.color.blue)
					fig.set_size (50)
					fig.set_point_position_relative (1, 1)
					fig.update
					update_layout
				end
			end
		end

feature {NONE} -- Implementation / Constants

	Window_title: STRING = "Splendid Algo"
			-- Title of the window.

	Window_width: INTEGER = 800
			-- Initial width for this window.

	Window_height: INTEGER = 600
			-- Initial height for this window.

	keep_alive (obj: ANY)
		do
			keep_alive_container.force (obj)
		end

	keep_alive_container: ARRAYED_LIST [ANY]
		once
			create Result.make (5)
		end

feature {NONE} -- World Implementation

	tree_service: TREE_SERVICE

	world: EG_FIGURE_WORLD

	model_cell: WORLD_CELL --EV_MODEL_WORLD_CELL

	tree_layout: EG_TREE_LAYOUT

end