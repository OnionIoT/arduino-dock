CODE_DIR = twiboot

.PHONY: subdirs

subdirs:
	$(MAKE) -C $(CODE_DIR)

clean:
	$(MAKE) -C $(CODE_DIR) clean