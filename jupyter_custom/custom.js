
require(['base/js/namespace', 'base/js/events'], function(IPython, events) {
    var hideHeaders = function(events) {
        $('#header-container').toggle(); 
        $('.header-bar').toggle();       
        $('div#maintoolbar').toggle();
        events.trigger('resize-header.Page');
    };

    var initNotebook = function() {
        hideHeaders(events);

        IPython.keyboard_manager.command_shortcuts.add_shortcut('ctrl-k', function (event) {
            IPython.notebook.move_selection_up();
            return false;
        });

        IPython.keyboard_manager.command_shortcuts.add_shortcut('ctrl-j', function (event) {
            IPython.notebook.move_selection_down();
            return false;
        });
    };

    events.on('notebook_loaded.Notebook', initNotebook);
    events.on('app_initialized.NotebookApp', initNotebook);
});
