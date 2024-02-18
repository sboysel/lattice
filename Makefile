# author: Sam Boysel <sboysel@gmail.com>
# adapted from https://github.com/infused-kim/kb_think_corney
.PHONY: all install ergogen gerbers
GERBERS_PATH=prod/gerbers

all: ergogen

install:
	@echo "Installing ergogen..."
	@npm install

ergogen: ./ergogen/config.yaml
	@echo "Clean up ergogen..."
	@rm -rf ./ergogen/output
	@echo "Running ergogen..."
	@npx ergogen ./ergogen -o ./ergogen/output
	@echo "Post-processing..."
	@sed -i 's/page A3/page A4/' ./ergogen/output/pcbs/lattice_left.kicad_pcb
	@cp ./ergogen/output/pcbs/lattice_left.kicad_pcb ./prod/lattice_left.kicad_pcb

gerbers: prod/lattice_left.kicad_pcb
	@echo "Cleaning up old gerbers..."
	@rm -rf $(GERBERS_PATH)
	@mkdir -p $(GERBERS_PATH)/lattice_left
	@echo "Generating gerbers..."
	@kicad-cli pcb export gerbers prod/lattice_left.kicad_pcb -o $(GERBERS_PATH)/lattice_left
	@echo "Generating drill files..."
	@kicad-cli pcb export drill prod/lattice_left.kicad_pcb -o $(GERBERS_PATH)/lattice_left
	@echo "Compressing gerbers..."
	zip -jr $(GERBERS_PATH)/lattice_left.zip $(GERBERS_PATH)/lattice_left
