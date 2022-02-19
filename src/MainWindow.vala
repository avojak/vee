/*
 * Copyright (c) 2021 Andrew Vojak (https://avojak.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Authored by: Andrew Vojak <andrew.vojak@gmail.com>
 */

public class Vee.MainWindow : Hdy.Window {

    public unowned Vee.Application app { get; construct; }

    private Vee.Widgets.Dialogs.DebugDialog? debug_dialog = null;

    private Vee.MainLayout main_layout;

    private Vee.Emulator? emulator;

    public MainWindow (Vee.Application application) {
        Object (
            application: application,
            app: application,
            border_width: 0,
            resizable: true,
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    construct {
        main_layout = new Vee.MainLayout (this);
        add (main_layout);

        move (Vee.Application.settings.get_int ("pos-x"), Vee.Application.settings.get_int ("pos-y"));
        resize (Vee.Application.settings.get_int ("window-width"), Vee.Application.settings.get_int ("window-height"));

        this.destroy.connect (() => {
            // Do stuff before closing the application

            // Stop running emulator
            if (emulator != null) {
                emulator.stop ();
            }

            //  GLib.Process.exit (0);
        });

        this.delete_event.connect (before_destroy);

        main_layout.start_button_clicked.connect (on_start_button_clicked);
        main_layout.stop_button_clicked.connect (on_stop_button_clicked);
        main_layout.debug_button_clicked.connect (on_debug_button_clicked);

        show_app ();
    }

    public void show_app () {
        show_all ();
        show ();
        present ();
    }

    public bool before_destroy () {
        update_position_settings ();
        destroy ();
        return true;
    }

    private void update_position_settings () {
        int width, height, x, y;

        get_size (out width, out height);
        get_position (out x, out y);

        Vee.Application.settings.set_int ("pos-x", x);
        Vee.Application.settings.set_int ("pos-y", y);
        Vee.Application.settings.set_int ("window-width", width);
        Vee.Application.settings.set_int ("window-height", height);
    }

    public void on_start_button_clicked (string rom_uri) {
        // TODO: Add named view for the emulator
        if (emulator != null) {
            return;
        }
        //  emulator = new Vee.DMG.Emulator ();
        emulator = new Vee.CHIP8.Interpreter ();
        // TODO: Handle when ROM file not found
        //  emulator.load_rom (GLib.File.new_for_path (Constants.PKG_DATA_DIR + "/" + "IBM Logo.ch8"));
        //  emulator.load_rom (GLib.File.new_for_path (Constants.PKG_DATA_DIR + "/" + "test_opcode.ch8"));
        //  emulator.load_rom (GLib.File.new_for_path (Constants.PKG_DATA_DIR + "/" + "Pong (alt).ch8"));
        //  emulator.load_rom (GLib.File.new_for_path (Constants.PKG_DATA_DIR + "/" + "c8_test.c8"));
        emulator.load_rom (GLib.File.new_for_uri (rom_uri));
        emulator.closed.connect (() => {
            emulator = null;
        });
        //  emulator.show (this);
        main_layout.set_emulator_display (emulator.get_display ());
        main_layout.set_emulator_debug_display (emulator.get_debug_display ());
        emulator.start ();
    }

    public void on_stop_button_clicked () {
        if (emulator == null) {
            return;
        }
        emulator.stop ();
        main_layout.remove_emulator_display (emulator.get_display ());
        main_layout.remove_emulator_debug_display (emulator.get_debug_display ());
        //  emulator.hide ();
        emulator = null;
    }

    public void on_debug_button_clicked () {
        if (debug_dialog == null) {
            debug_dialog = new Vee.Widgets.Dialogs.DebugDialog (this);
            debug_dialog.show_all ();
            debug_dialog.destroy.connect (() => {
                debug_dialog = null;
            });
        }
        debug_dialog.present ();
    }

}
