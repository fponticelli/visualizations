package model;

typedef ConfigObject = {
	cacheExpires			: Float,
	duration				: Null<Float>,
	allowedFormats			: Array<String>,
	params					: Dynamic,
	defaults				: Dynamic,
	zoom					: Null<Float>,
	// PDF
	dpi						: Null<Int>,
	grayscale				: Bool,
	imageDpi				: Null<Int>,
	imageQuality			: Null<Int>,
	lowQuality				: Bool,
	marginTop				: Null<String>,
	marginBottom			: Null<String>,
	marginLeft				: Null<String>,
	marginRight				: Null<String>,
	portrait				: Bool,
	pageHeight				: Null<String>,
	pageSize				: Null<String>,
	pageWidth				: Null<String>,
	title					: Null<String>,
	usePrintMediaType		: Bool,
	disableSmartShrinking	: Bool,

	footerCenter			: Null<String>,
	footerLeft				: Null<String>,
	footerRight				: Null<String>,
	footerFontName			: Null<String>,
	footerFontSize			: Null<String>,
	footerHtml				: Null<String>,
	footerSpacing			: Null<Float>,
	footerLine				: Bool,

	headerCenter			: Null<String>,
	headerLeft				: Null<String>,
	headerRight				: Null<String>,
	headerFontName			: Null<String>,
	headerFontSize			: Null<String>,
	headerHtml				: Null<String>,
	headerSpacing			: Null<Float>,
	headerLine				: Bool,
// IMAGE
	x						: Null<Int>,
	y						: Null<Int>,
	width					: Null<Int>,
	height					: Null<Int>,
	screenWidth				: Null<Int>,
	screenHeight			: Null<Int>,
	quality					: Null<Int>,
	disableSmartWidth		: Bool,
	transparent				: Bool
}