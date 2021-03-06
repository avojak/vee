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

public class Vee.CHIP8.Graphics.Widgets.Display : Gtk.Grid {

    public unowned Vee.CHIP8.Graphics.PPU ppu { get; construct; }
    
    private const int BASE_SCALING = 8; // Base scaling factor to have a reasonable default display size

    public Display (Vee.CHIP8.Graphics.PPU ppu) {
        Object (
            expand: true,
            ppu: ppu
        );
    }

    construct {
        var drawing_area = new Gtk.DrawingArea ();
        drawing_area.width_request = Vee.CHIP8.Graphics.PPU.WIDTH * BASE_SCALING;
        drawing_area.height_request = Vee.CHIP8.Graphics.PPU.HEIGHT * BASE_SCALING;
        drawing_area.draw.connect (on_draw);

        add (drawing_area);

        ppu.display_data_changed.connect (queue_draw);

        show_all ();
    }

    private bool on_draw (Gtk.Widget da, Cairo.Context ctx) {
        ctx.save ();
        for (int row = 0; row < Vee.CHIP8.Graphics.PPU.HEIGHT; row++) {
            for (int col = 0; col < Vee.CHIP8.Graphics.PPU.WIDTH; col++) {
                int color = ppu.get_pixel (col, row); // * 255;
                ctx.set_source_rgb (color, color, color);
                ctx.new_path ();
                ctx.move_to (col * BASE_SCALING, row * BASE_SCALING);
                ctx.rel_line_to (BASE_SCALING, 0);
                ctx.rel_line_to (0, BASE_SCALING);
                ctx.rel_line_to (-BASE_SCALING, 0);
                ctx.close_path ();
                ctx.fill ();
            }
        }
        ctx.restore ();
        return true;
    }

}
