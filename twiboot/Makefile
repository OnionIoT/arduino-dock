TARGETS = twiboot
TARGET_DIR = bin
BUILD_DIR = build

CFLAGS= -pipe -O2 -Wall -Wno-unused-result
CFLAGS+= -MMD -MP -MF $(BUILD_DIR)/$(*D)/$(*F).d
LDFLAGS=

# ------

SRC:= $(wildcard *.c)

all: $(TARGETS)

$(TARGETS): $(patsubst %,$(BUILD_DIR)/%, $(SRC:.c=.o))
	@echo " Linking file:  $@"
	@mkdir -p $(TARGET_DIR)
	@echo "$(CC) $(CFLAGS) $^ -o $(TARGET_DIR)/$@ $(LDFLAGS)" ; $(CC) $(CFLAGS) $^ -o $(TARGET_DIR)/$@ $(LDFLAGS) > /dev/null

$(BUILD_DIR)/%.o: %.c $(MAKEFILE_LIST)
	@echo " Building file: $<"
	@$(shell test -d $(BUILD_DIR)/$(*D) || mkdir -p $(BUILD_DIR)/$(*D))
	@echo "$(CC) $(CFLAGS) -o $@ -c $<" ; $(CC) $(CFLAGS) -o $@ -c $<

clean:
	rm -rf $(BUILD_DIR) $(TARGET_DIR)/$(TARGETS)

-include $(shell find $(BUILD_DIR) -name \*.d 2> /dev/null)
