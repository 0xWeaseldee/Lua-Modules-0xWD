---
-- @Liquipedia
-- page=Module:Widget/TeamDisplay/Inline
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

local Lua = require('Module:Lua')

local Array = Lua.import('Module:Array')
local Class = Lua.import('Module:Class')
local Logic = Lua.import('Module:Logic')
local Table = Lua.import('Module:Table')
local TeamTemplate = Lua.import('Module:TeamTemplate')

local Widget = Lua.import('Module:Widget')
local HtmlWidgets = Lua.import('Module:Widget/Html/All')
local Span = HtmlWidgets.Span
local TeamIcon = Lua.import('Module:Widget/Image/Icon/TeamIcon')
local TeamName = Lua.import('Module:Widget/TeamDisplay/Component/Name')
local WidgetUtil = Lua.import('Module:Widget/Util')

---@class InlineType
---@field displayType string
---@field displayNames table<string, string[]>

---@type table<teamStyle, InlineType>
local TEAM_INLINE_TYPES = {
	['bracket'] = {
		displayType = 'bracket',
		displayNames = {['bracketname'] = {}}
	},
	['icon'] = {
		displayType = 'icon',
		displayNames = {}
	},
	['short'] = {
		displayType = 'short',
		displayNames = {['shortname'] = {}}
	},
	['standard'] = {
		displayType = 'standard',
		displayNames = {['name'] = {}}
	},
	['hybrid'] = {
		displayType = 'standard',
		displayNames = {
			['bracketname'] = {'mobile-hide'},
			['shortname'] = {'mobile-only'}
		}
	}
}

---@class TeamInlineParameters
---@field name string?
---@field date number|string?
---@field teamTemplate teamTemplateData?
---@field flip boolean?
---@field displayType teamStyle

---@class TeamInlineWidget: Widget
---@operator call(TeamInlineParameters): TeamInlineWidget
---@field name string?
---@field props TeamInlineParameters
---@field teamTemplate teamTemplateData
---@field flip boolean
---@field displayType InlineType
local TeamInlineWidget = Class.new(Widget,
	---@param self self
	---@param input TeamInlineParameters
	function (self, input)
		assert(TEAM_INLINE_TYPES[input.displayType], 'Invalid display type')
		self.teamTemplate = input.teamTemplate or TeamTemplate.getRawOrNil(input.name, input.date)
		self.name = (self.teamTemplate or {}).name or input.name
		self.flip = Logic.readBool(input.flip)
		self.displayType = TEAM_INLINE_TYPES[input.displayType]
	end
)

---@return Widget
function TeamInlineWidget:render()
	local teamTemplate = self.teamTemplate
	if not teamTemplate then
		mw.ext.TeamLiquidIntegration.add_category('Pages with missing team templates')
		return HtmlWidgets.Small{
			classes = { 'error' },
			children = { TeamTemplate.noTeamMessage(self.name) }
		}
	end
	local flip = self.flip
	local imageLight = Logic.emptyOr(teamTemplate.image, teamTemplate.legacyimage)
	local imageDark = Logic.emptyOr(teamTemplate.imagedark, teamTemplate.legacyimagedark)
	local children = Array.interleave(WidgetUtil.collect(
		TeamIcon{
			imageLight = imageLight,
			imageDark = imageDark,
			page = teamTemplate.page,
			legacy = Logic.isEmpty(teamTemplate.image) and Logic.isNotEmpty(teamTemplate.legacyimage),
			noLink = teamTemplate.page == 'TBD',
		},
		self:_getNameComponent()
	), ' ')
	return Span{
		attributes = { ['data-highlighting-class'] = self.teamTemplate.name },
		classes = { 'team-template-team' .. (flip and '2' or '') .. '-' .. self.displayType.displayType },
		children = flip and Array.reverse(children) or children
	}
end

---@private
---@return Widget
function TeamInlineWidget:_getNameComponent()
	return HtmlWidgets.Fragment{
		children = Array.map(Table.entries(self.displayType.displayNames), function (element)
			return TeamName{
				additionalClasses = element[2],
				displayName = self.teamTemplate[element[1]],
				page = self.teamTemplate.page,
				noLink = self.teamTemplate.page == 'TBD',
			}
		end)
	}
end

return TeamInlineWidget
