extends Node

var matter: MatterBag = MatterBag.new()

var absorber: Absorber = StarterAbsorber.new()

@export_group("Options")

## Does the player want us to use VSync?
@export var use_vsync: bool = true

## Use the short symbols or the full names for matter?
@export var use_symbols: bool = false

## Which number format should we use?
@export var use_format: NumberTools.NumberFormat = NumberTools.NumberFormat.NONE

## What should we use to separate decimals from fractions?
@export var number_decimal_separator: NumberTools.NumberDecimalSeparator = (
	NumberTools.NumberDecimalSeparator.PERIOD
)

## What should we use to separate number groups. i.e., the comma thousands in the USA.
@export var number_grouping_separator: NumberTools.NumberGroupSeparator = (
	NumberTools.NumberGroupSeparator.COMMA
)

@export_group("")
