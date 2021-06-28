package require Tk

wm title . "Machine Parts Solver"

source "lgt_query.tcl"

# Window layout
grid [ttk::frame .c -padding "3 3 12 12"] -column 0 -row 0 -sticky wnes
grid [ttk::frame .statusbar -relief sunken -height 64 -padding "3"] -column 0 -row 1 -sticky wes
grid columnconfigure	. 0 -weight 1
grid rowconfigure		. 0 -weight 1

# .c contents
# Headings
grid [ttk::label .c.time_lbl -text "Time (hours) on" -font TkHeadingFont] -column 1 -row 0 -columnspan 3 -sticky nwe
grid [ttk::label .c.part_type_lbl -text "Part Type" -font TkHeadingFont] -column 0 -row 1 -sticky ws
grid [ttk::label .c.lathe_lbl -text "Lathe" -font TkHeadingFont] -column 1 -row 1 -sticky ws
grid [ttk::label .c.polisher_lbl -text "Polisher" -font TkHeadingFont] -column 2 -row 1 -sticky ws
grid [ttk::label .c.press_lbl -text "Press" -font TkHeadingFont] -column 3 -row 1 -sticky ws
grid [ttk::label .c.unit_profit_lbl -text "Unit Profit" -font TkHeadingFont] -column 4 -row 1 -sticky ws

# Info
grid [ttk::label .c.unit_a_lbl -text "Unit A"] -column 0 -row 2
grid [ttk::label .c.unit_a_lathe_lbl -text "0.1" -anchor e] -column 1 -row 2
grid [ttk::label .c.unit_a_polisher_lbl -text "0.2" -anchor e] -column 2 -row 2
grid [ttk::label .c.unit_a_press_lbl -text "0.4" -anchor e] -column 3 -row 2
grid [ttk::label .c.unit_a_unit_profit_lbl -text "\$16" -anchor e] -column 4 -row 2

grid [ttk::label .c.unit_b_lbl -text "Unit B"] -column 0 -row 3
grid [ttk::label .c.unit_b_lathe_lbl -text "0.2" -anchor e] -column 1 -row 3
grid [ttk::label .c.unit_b_polisher_lbl -text "0.1" -anchor e] -column 2 -row 3
grid [ttk::label .c.unit_b_press_lbl -text "0.1" -anchor e] -column 3 -row 3
grid [ttk::label .c.unit_b_unit_profit_lbl -text "\$25" -anchor e] -column 4 -row 3

# Input
grid [ttk::label .c.avail_lbl -text "Available (hours)" -font TkHeadingFont] -column 0 -row 4
grid [ttk::entry .c.lathe_hours_entry -width 4 -textvariable lathe_hours] -column 1 -row 4
grid [ttk::entry .c.polisher_hours_entry -width 4 -textvariable polisher_hours] -column 2 -row 4
grid [ttk::entry .c.press_hours_entry -width 4 -textvariable press_hours] -column 3 -row 4
grid [ttk::button .c.calc -text "Calculate" -command calculate] -column 4 -row 5

# Results
grid [ttk::label .c.result_lbl -text "To Produce" -font TkHeadingFont] -column 5 -row 1
grid [ttk::label .c.unit_a_result -textvariable unit_a_count -relief ridge -padding "3" -width 4 -anchor e] -column 5 -row 2
grid [ttk::label .c.unit_b_result -textvariable unit_b_count -relief ridge -padding "3" -width 4 -anchor e] -column 5 -row 3
grid [ttk::label .c.profit_lbl -text "Profit" -font TkHeadingFont] -column 0 -row 5
grid [ttk::label .c.profit_result -textvariable profit -relief ridge -padding "3" -width 8 -anchor e] -column 1 -row 5

# Some nice padding
foreach w [winfo children .c] {grid configure $w -padx 5 -pady 5}

# Status Bar
grid [ttk::label .statusbar.status_lbl -text "Status:"] -column 0 -row 0 -sticky ws
grid [ttk::label .statusbar.status_msg -textvariable status] -column 1 -row 0 -sticky wes

# Setup
# Default values
set ::lathe_hours 160
set ::polisher_hours 120
set ::press_hours 150
set ::status "loading"
# Focus on first input
focus .c.lathe_hours_entry
# Connect Logtalk
lgt::connect
set ::status "connected"
# Override closing window so we can disconnect Logtalk
wm protocol . WM_DELETE_WINDOW on_close

proc on_close {} {
	# When closing the window disconnect Logtalk, then destroy the window
	lgt::disconnect
	set ::status "disconnected"
	destroy .
}

proc calculate {} {
	# Get the vars and send it to Logtalk to solve
	set ::status "solving"
	set query "solver::solve($::lathe_hours, $::polisher_hours, $::press_hours, UnitA, UnitB, Profit)"
	# puts $query
	set response [lgt::query $query]
	# Log response
	puts $response
	set ::status "solved"
	switch [dict get $response status] {
		"success" {show_results [dict get $response unifications]}
		"error" {on_error [dict get $response error]"}
		"fail" {on_fail}
	}
}

proc show_results {unifications} {
	# Update the text variables to show the unifications
	set ::unit_a_count [dict get $unifications UnitA]
	set ::unit_b_count [dict get $unifications UnitB]
	set ::profit "\$[dict get $unifications Profit]"
}

proc on_error {error_msg} {
	# Update status
	set ::status "Error -> $error_msg"
	clear_results
}

proc on_fail {} {
	# Update status
	set ::status "Failed"
	clear_results
}

proc clear_results {} {
	# Clear any set results
	set ::unit_a_count ""
	set ::unit_b_count ""
	set ::profit ""
}
