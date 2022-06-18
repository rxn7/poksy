extends Node

const type_translations: Dictionary = {
	"normal": "normalny",
	"fire": "ognisty",
	"water": "wodnisty",
	"electric": "elektryczny",
	"grass": "trawiasty",
	"ice": "lodowy",
	"fighting": "walczący",
	"poison": "trujący",
	"ground": "lądowy",
	"flying": "latający",
	"psychic": "psychiczny",
	"bug": "robak",
	"rock": "kamień",
	"ghost": "duch",
	"dragon": "smok",
	"dark": "mroczny",
	"steel": "stalowy",
	"fairy": "wróżka"
}

func get_type_translation(type: String):
	if !type_translations.has(type):
		printerr("Type '%s' has no translation!" % type);
		return "";

	return type_translations[type];
