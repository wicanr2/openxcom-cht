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

		// zh-TW UX fix v2 (designer pass):
		//   * vanilla blockOffset(14)+15  = idx 239 = #503020 warm brown (L=55)
		//       -> on UP004.SPK sky+cloud (L=130..230) contrast OK for english
		//          stroke but 12x12 CJK strokes vanish.
		//   * v1 attempt blockOffset(15)+15 = idx 255 = #A4C068 LIGHT yellow-
		//       green (L=173) -- block 15 in PAL_UFOPAEDIA is NOT a black ramp
		//       like other blocks, the upper half (252-255) is a pale lime
		//       sequence. That is why "255" looked invisible: similar luminance
		//       to the cloud background.
		//   * v2 choice: blockOffset(15)+9 = idx 249 = #14282C dark teal
		//     (L=34.5) in PAL_UFOPAEDIA. The same index is #0C3054 dark navy
		//     (L=41.3) in PAL_BATTLEPEDIA (used by craft weapon screen). Both
		//     are dark cool neutrals that contrast strongly with the sky
		//     palette (cloud bytes 32,128,129,130,133-141 all have L>=115).
		//   * secondary keeps blockOffset(15)+4 = idx 244 = #1C1C20 deep
		//     neutral so stat values remain distinguishable from labels.
		//   * setHighContrast(true) thickens the AA edge (mul=3 in Text.cpp),
		//     which on a dark-on-light layout reinforces the outline of CJK
		//     strokes against the sky.
		_txtTitle->setColor(Palette::blockOffset(15)+9);
		_txtTitle->setHighContrast(true);
		_txtTitle->setBig();
		_txtTitle->setWordWrap(true);
		_txtTitle->setText(tr(defs->title));

		_txtInfo = new Text(defs->rect_text.width, defs->rect_text.height, defs->rect_text.x, defs->rect_text.y);
		add(_txtInfo);

		_txtInfo->setColor(Palette::blockOffset(15)+9);
		_txtInfo->setHighContrast(true);
		_txtInfo->setWordWrap(true);
		_txtInfo->setScrollable(true);
		_txtInfo->setText(tr(defs->text));

		_txtStats = new Text(defs->rect_stats.width, defs->rect_stats.height, defs->rect_stats.x, defs->rect_stats.y);
		add(_txtStats);

		_txtStats->setColor(Palette::blockOffset(15)+9);
		_txtStats->setSecondaryColor(Palette::blockOffset(15)+4);
		_txtStats->setHighContrast(true);

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
