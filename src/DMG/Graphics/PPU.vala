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

public class Replay.DMG.Graphics.PPU : GLib.Object {

    public Mode mode { get; set; }

    public enum Mode {
        HBLANK, VBLANK, OAM_SEARCH, PIXEL_TRANSFER;
    }

    construct {
        mode = Mode.OAM_SEARCH;
    }

    public void tick () {
        switch (mode) {
            case HBLANK:
                break;
            case VBLANK:
                break;
            case OAM_SEARCH:
                break;
            case PIXEL_TRANSFER:
                break;
            default:
                assert_not_reached ();
        }
    }

}
