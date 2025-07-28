##
# LateX Template
##

# Compilers
LC := lualatex
PDF2PNG := magick

# Files & paths
TARGET := filename
SRC_PATH := src
IMG_PATH := img
OUTPUT_PATH := out


DIAGRAM_PATH := diagram
DIAGRAM_SRC_PATH := diagram_src
DIAGRAM_SRC := $(wildcard $(DIAGRAM_SRC_PATH)/*.tex)
DIAGRAM_PNGS := $(patsubst $(DIAGRAM_SRC_PATH)/%.tex, $(DIAGRAM_PATH)/%.png, $(DIAGRAM_SRC))

################################################################################

default: makedir all

diagrams: $(DIAGRAM_PNGS)
all: $(OUTPUT_PATH)/$(TARGET).pdf

################################################################################

# Make directories if they don't exist
.PHONY: makedir
makedir:
	mkdir -p $(DIAGRAM_PATH) $(DIAGRAM_SRC_PATH) $(SRC_PATH) $(IMG_PATH) $(OUTPUT_PATH)

# Compile diagrams to images
$(DIAGRAM_PATH)/%.png: $(DIAGRAM_SRC_PATH)/%.tex
	$(LC) --interaction=nonstopmode --output-directory=$(DIAGRAM_PATH) $<
	$(PDF2PNG) -density 600 $(DIAGRAM_PATH)/$*.pdf -trim +repage -fuzz 50% -quality 100 $(DIAGRAM_PATH)/$*.png
	rm $(DIAGRAM_PATH)/*.pdf

# Make main pdf
$(OUTPUT_PATH)/$(TARGET).pdf: diagrams
$(OUTPUT_PATH)/$(TARGET).pdf: $(SRC_PATH)/$(TARGET).tex
	$(LC) --output-directory=$(OUTPUT_PATH) $(SRC_PATH)/$(TARGET).tex

# end
