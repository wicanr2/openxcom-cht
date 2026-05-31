/*
 * Copyright 2010-2016 OpenXcom Developers.
 *
 * This file is part of OpenXcom.
 *
 * OpenXcom is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OpenXcom is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OpenXcom.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <sstream>
#include "ArticleStateCraft.h"
#include "../Mod/ArticleDefinition.h"
#include "../Mod/Mod.h"
#include "../Mod/RuleCraft.h"
#include "../Engine/Game.h"
#include "../Engine/Palette.h"
#include "../Engine/Surface.h"
#include "../Engine/LocalizedText.h"
#include "../Engine/Unicode.h"
#include "../Interface/Text.h"
#include "../Interface/TextButton.h"

namespace OpenXcom
{

	ArticleStateCraft::ArticleStateCraft(ArticleDefinitionCraft *defs) : ArticleState(defs->id)
	{
		RuleCraft *craft = _game->getMod()->getCraft(defs->id, true);

		// add screen elements
		_txtTitle = new Text(210, 32, 5, 24);

		// Set palette
		setPalette("PAL_UFOPAEDIA");

		ArticleState::initLayout();

		// add other elements
		add(_txtTitle);

		// Set up objects
		_game->getMod()->getSurface(defs->image_id)->blit(_bg);
		_btnOk->setColor(Palette::blockOffset(15)-1);
		_btnPrev->setColor(Palette::blockOffset(15)-1);
		_btnNext->setColor(Palette::blockOffset(15)-1);

		// zh-TW UX fix v2 (designer pass, second iteration):
		//
		// CRITICAL: X-COM Text rendering uses PaletteShift in Text.cpp:466 --
		//     dest_palette_index = color + src * mul
		// where src is the font glyph's internal pixel value 1..5 (anti-alias
		// shade) and mul = 1 normal / 3 if setHighContrast(true). The "color"
		// arg is therefore the RAMP BASE; the visible pixels land on
		// [color+1 .. color+5], NOT on `color` itself. Choosing a base whose
		// next 5 indexes are a coherent dark ramp is the actual goal.
		//
		// History:
		//   * vanilla blockOffset(14)+15 = 239 -> pixels at 240..244, which in
		//     PAL_UFOPAEDIA is a purple-to-near-black ramp. Decent contrast
		//     on dark backgrounds, marginal on UP004.SPK sky.
		//   * v1 blockOffset(15)+15 = 255 -> pixels wrap to idx 0..4 (black,
		//     then pale cream #FCFCE4 etc.) -> invisible on white clouds.
		//   * v2-first-attempt blockOffset(15)+9 = 249 -> pixels at 250..254,
		//     which are magenta(250,251) + pale lime(252..254). Rendered as
		//     bright yellow text -- still poor contrast.
		//   * v2 final = blockOffset(14)+10 = 234 -> pixels at 235..239 =
		//       PAL_UFOPAEDIA:   #7C5440 .. #503020  L=93.7..55.7 dark brown
		//       PAL_BATTLEPEDIA: #484064 .. #201830  L=70.5..29.1 dark purple
		//     Both are uniform dark ramps in same block 14, no wrapping.
		//     mul=1 (no setHighContrast) keeps the ramp contiguous; setting
		//     contrast=3 would scatter src*3 across multiple blocks (e.g.
		//     into magenta 250,251) and break the look.
		//   * Secondary keeps blockOffset(15)+4 = 244 = #1C1C20 deep neutral
		//     so stat values remain distinguishable from labels.
		_txtTitle->setColor(Palette::blockOffset(14)+10);
		_txtTitle->setBig();
		_txtTitle->setWordWrap(true);
		_txtTitle->setText(tr(defs->title));

		_txtInfo = new Text(defs->rect_text.width, defs->rect_text.height, defs->rect_text.x, defs->rect_text.y);
		add(_txtInfo);

		_txtInfo->setColor(Palette::blockOffset(14)+10);
		_txtInfo->setWordWrap(true);
		_txtInfo->setScrollable(true);
		_txtInfo->setText(tr(defs->text));

		_txtStats = new Text(defs->rect_stats.width, defs->rect_stats.height, defs->rect_stats.x, defs->rect_stats.y);
		add(_txtStats);

		_txtStats->setColor(Palette::blockOffset(14)+10);
		_txtStats->setSecondaryColor(Palette::blockOffset(15)+4);

		std::ostringstream ss;
		ss << tr("STR_MAXIMUM_SPEED_UC").arg(Unicode::formatNumber(craft->getMaxSpeed())) << '\n';
		ss << tr("STR_ACCELERATION").arg(craft->getAcceleration()) << '\n';
		ss << tr("STR_FUEL_CAPACITY").arg(Unicode::formatNumber(craft->getMaxFuel())) << '\n';
		ss << tr("STR_WEAPON_PODS").arg(craft->getWeapons()) << '\n';
		ss << tr("STR_DAMAGE_CAPACITY_UC").arg(Unicode::formatNumber(craft->getMaxDamage())) << '\n';
		ss << tr("STR_CARGO_SPACE").arg(craft->getSoldiers()) << '\n';
		ss << tr("STR_HWP_CAPACITY").arg(craft->getVehicles());
		_txtStats->setText(ss.str());

		centerAllSurfaces();
	}

	ArticleStateCraft::~ArticleStateCraft()
	{}

}
