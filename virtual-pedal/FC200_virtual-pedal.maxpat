{
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 9,
            "minor": 2,
            "revision": 1,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [ 524.0, 157.0, 1498.0, 709.0 ],
        "boxes": [
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 364.0, 65.0, 144.0, 22.0 ],
                    "text": "midiout @name \"SSL 2+\""
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 168.0, 143.0, 145.0, 22.0 ],
                    "text": "sysexin @name \"SSL 2+\""
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 207.0, 28.0, 143.0, 22.0 ],
                    "text": "midiin @name \"to Max 1\""
                }
            },
            {
                "box": {
                    "id": "obj-7",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 37.0, 209.33333957195282, 165.0, 22.0 ],
                    "text": "midiout @name \"from Max 1\""
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 2,
                            "revision": 1,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 735.0, 334.0, 1349.0, 630.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "comment": "[list] body",
                                    "id": "obj-8",
                                    "ignoreclick": 1,
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 484.611145, 407.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "[list] SysEx message",
                                    "id": "obj-4",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 86.166687, 3.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-593",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 471.022339, 175.5, 173.0, 22.0 ],
                                    "text": "240 65 0 114 18 0 0 127 0 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-480",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 484.611145, 370.0, 133.444458, 22.0 ],
                                    "text": "pack 1 2 3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-121",
                                    "linecount": 3,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 713.500061, 241.0, 50.0, 47.0 ],
                                    "text": "End of exclusive"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-122",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 427.388977, 241.0, 50.0, 33.0 ],
                                    "text": "Command ID"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-123",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 370.166748, 241.0, 50.0, 33.0 ],
                                    "text": "Model ID"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-124",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 312.944519, 241.0, 50.0, 33.0 ],
                                    "text": "Device ID"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-125",
                                    "linecount": 3,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 255.72229, 241.0, 50.0, 47.0 ],
                                    "text": "Manufacturer ID"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-126",
                                    "linecount": 3,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 198.500061, 241.0, 50.0, 47.0 ],
                                    "text": "Exclusive Status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-113",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "zlclear" ],
                                    "patching_rect": [ 86.166687, 69.0, 52.0, 22.0 ],
                                    "text": "t zlclear"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-114",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "zlclear", "bang" ],
                                    "patching_rect": [ 157.833374, 69.0, 62.0, 22.0 ],
                                    "text": "t zlclear b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-115",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 229.500061, 175.5, 74.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-116",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 229.500061, 146.5, 78.0, 22.0 ],
                                    "text": "prepend 240"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-117",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 229.500061, 112.0, 175.0, 22.0 ],
                                    "text": "zl group 9999 @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-118",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "" ],
                                    "patching_rect": [ 86.166687, 42.0, 162.0, 22.0 ],
                                    "text": "sel 240 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-66",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 427.388977, 293.0, 50.0, 22.0 ],
                                    "text": "18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-67",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 370.166748, 293.0, 50.0, 22.0 ],
                                    "text": "114"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-68",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 312.944519, 293.0, 50.0, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-69",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 255.72229, 293.0, 50.0, 22.0 ],
                                    "text": "65"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-70",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 198.500061, 293.0, 50.0, 22.0 ],
                                    "text": "240"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 713.500061, 293.0, 50.0, 22.0 ],
                                    "text": "247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-64",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 656.277832, 293.0, 50.0, 22.0 ],
                                    "text": "118"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-63",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 599.055603, 293.0, 50.0, 22.0 ],
                                    "text": "8"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-62",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 541.833374, 293.0, 50.0, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 484.611145, 293.0, 50.0, 22.0 ],
                                    "text": "2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 10,
                                    "outlettype": [ "int", "int", "int", "int", "int", "int", "int", "int", "int", "int" ],
                                    "patching_rect": [ 229.500061, 209.0, 534.0, 22.0 ],
                                    "text": "unpack 1 2 3 4 5 6 7 8 9 10"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-117", 0 ],
                                    "midpoints": [ 95.666687, 108.0, 239.000061, 108.0 ],
                                    "source": [ "obj-113", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-117", 0 ],
                                    "midpoints": [ 210.333374, 107.0, 239.000061, 107.0 ],
                                    "source": [ "obj-114", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-117", 0 ],
                                    "midpoints": [ 167.333374, 107.0, 239.000061, 107.0 ],
                                    "source": [ "obj-114", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-115", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-115", 0 ],
                                    "source": [ "obj-116", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-116", 0 ],
                                    "source": [ "obj-117", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-113", 0 ],
                                    "source": [ "obj-118", 0 ],
                                    "watchpoint_flags": 1,
                                    "watchpoint_id": 7
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-114", 0 ],
                                    "source": [ "obj-118", 1 ],
                                    "watchpoint_flags": 1,
                                    "watchpoint_id": 6
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-117", 0 ],
                                    "source": [ "obj-118", 2 ],
                                    "watchpoint_flags": 1,
                                    "watchpoint_id": 5
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-118", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-480", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-62", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-62", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-63", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 7 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-63", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 7 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-64", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 8 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-64", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 8 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 9 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 9 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-66", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-66", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-67", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-67", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-69", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-69", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-70", 1 ],
                                    "order": 0,
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-70", 0 ],
                                    "order": 1,
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-593", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-480", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-480", 1 ],
                                    "source": [ "obj-62", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-480", 2 ],
                                    "source": [ "obj-63", 0 ]
                                }
                            }
                        ],
                        "styles": [
                            {
                                "name": "AudioStatus_Menu",
                                "default": {
                                    "bgfillcolor": {
                                        "angle": 270.0,
                                        "autogradient": 0,
                                        "color": [ 0.294118, 0.313726, 0.337255, 1 ],
                                        "color1": [ 0.454902, 0.462745, 0.482353, 0.0 ],
                                        "color2": [ 0.290196, 0.309804, 0.301961, 1.0 ],
                                        "proportion": 0.39,
                                        "type": "color"
                                    }
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "pbblobtxt",
                                "default": {
                                    "clearcolor": [ 0.427451, 0.427451, 0.427451, 0.0 ],
                                    "fontface": [ 0 ],
                                    "fontname": [ "Arial Rounded MT Bold" ],
                                    "fontsize": [ 31.56365 ],
                                    "textcolor": [ 0.425833, 0.425833, 0.425833, 1.0 ],
                                    "textjustification": [ 1 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "pbpreset",
                                "default": {
                                    "accentcolor": [ 0.854902, 0.854902, 0.376471, 1.0 ],
                                    "bgcolor": [ 0.666667, 0.666667, 0.666667, 1.0 ],
                                    "color": [ 1.0, 0.4, 0.4, 1.0 ],
                                    "elementcolor": [ 0.425833, 0.425833, 0.425833, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "pbtextfield",
                                "default": {
                                    "clearcolor": [ 0.666667, 0.666667, 0.666667, 1.0 ],
                                    "fontface": [ 1 ],
                                    "fontname": [ "Arial Rounded MT Bold" ],
                                    "fontsize": [ 9.0 ],
                                    "textcolor": [ 0.425833, 0.425833, 0.425833, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "pbumenu",
                                "default": {
                                    "bgfillcolor": {
                                        "angle": 270.0,
                                        "autogradient": 0,
                                        "color": [ 0.666667, 0.666667, 0.666667, 1.0 ],
                                        "color1": [ 0.376471, 0.384314, 0.4, 1.0 ],
                                        "color2": [ 0.290196, 0.309804, 0.301961, 1.0 ],
                                        "proportion": 0.39,
                                        "type": "color"
                                    },
                                    "fontname": [ "Arial Rounded MT Bold" ],
                                    "fontsize": [ 9.0 ],
                                    "textcolor_inverse": [ 0.427451, 0.427451, 0.427451, 1.0 ],
                                    "textjustification": [ 1 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            }
                        ],
                        "bgcolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                        "editing_bgcolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ]
                    },
                    "patching_rect": [ 207.0, 65.0, 133.0, 22.0 ],
                    "saved_object_attributes": {
                        "editing_bgcolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                        "locked_bgcolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ]
                    },
                    "text": "patcher sysex_decoder"
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 37.0, 28.0, 76.0, 22.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 256.0, 132.0, 111.0, 22.0 ],
                    "text": "Virtual Pedal",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 37.0, 69.0, 35.0, 22.0 ],
                    "text": "open"
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 37.0, 107.0, 51.0, 22.0 ],
                    "text": "pcontrol"
                }
            },
            {
                "box": {
                    "id": "obj-1",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 2,
                            "revision": 1,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 70.0, 1024.0, 698.0, 171.0 ],
                        "openinpresentation": 1,
                        "visible": 1,
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-522",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1913.5, 1848.8, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-523",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1877.5, 1848.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-524",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "int", "int" ],
                                    "patching_rect": [ 1877.5, 1784.8, 93.66666666666667, 22.0 ],
                                    "text": "t i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-525",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1865.5, 1884.8, 106.66666666666667, 22.0 ],
                                    "text": "gate"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-526",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "" ],
                                    "patching_rect": [ 1877.5, 1816.8, 57.0, 22.0 ],
                                    "text": "sel 0 127"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-527",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1865.5, 2284.8, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-528",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1865.5, 2224.8, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-529",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1865.5, 2196.8, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-530",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1937.5, 2128.8, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-531",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1937.5, 2104.8, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-532",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1937.5, 2080.8, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-533",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 1865.5, 1932.8, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-534",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1865.5, 2156.8, 93.40000081062317, 22.0 ],
                                    "text": "zl.join"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-535",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1865.5, 2012.8, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-536",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1937.5, 2048.8, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-537",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1921.5, 1972.8, 29.5, 22.0 ],
                                    "text": "19"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-538",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1865.5, 1972.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-505",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1586.5, 1848.8, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-506",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1550.5, 1848.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-507",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "int", "int" ],
                                    "patching_rect": [ 1550.5, 1784.8, 93.66666666666667, 22.0 ],
                                    "text": "t i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-508",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1538.5, 1884.8, 106.66666666666667, 22.0 ],
                                    "text": "gate"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-509",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "" ],
                                    "patching_rect": [ 1550.5, 1816.8, 57.0, 22.0 ],
                                    "text": "sel 0 127"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-510",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1538.5, 2284.8, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-511",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1538.5, 2224.8, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-512",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1538.5, 2196.8, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-513",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1610.5, 2128.8, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-514",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1610.5, 2104.8, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-515",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1610.5, 2080.8, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-516",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 1538.5, 1932.8, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-517",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1538.5, 2156.8, 93.40000081062317, 22.0 ],
                                    "text": "zl.join"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-518",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1538.5, 2012.8, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-519",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1610.5, 2048.8, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-520",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1594.5, 1972.8, 29.5, 22.0 ],
                                    "text": "18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-521",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1538.5, 1972.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-488",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1259.5, 1848.8, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-489",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1223.5, 1848.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-490",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "int", "int" ],
                                    "patching_rect": [ 1223.5, 1784.8, 93.66666666666667, 22.0 ],
                                    "text": "t i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-491",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1211.5, 1884.8, 106.66666666666667, 22.0 ],
                                    "text": "gate"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-492",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "" ],
                                    "patching_rect": [ 1223.5, 1816.8, 57.0, 22.0 ],
                                    "text": "sel 0 127"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-493",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1211.5, 2284.8, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-494",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1211.5, 2224.8, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-495",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1211.5, 2196.8, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-496",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1283.5, 2128.8, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-497",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1283.5, 2104.8, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-498",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1283.5, 2080.8, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-499",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 1211.5, 1932.8, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-500",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1211.5, 2156.8, 93.40000081062317, 22.0 ],
                                    "text": "zl.join"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-501",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1211.5, 2012.8, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-502",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1283.5, 2048.8, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-503",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1267.5, 1972.8, 29.5, 22.0 ],
                                    "text": "17"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-504",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1211.5, 1972.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-471",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 932.5, 1848.8, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-472",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 896.5, 1848.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-473",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "int", "int" ],
                                    "patching_rect": [ 896.5, 1784.8, 93.66666666666667, 22.0 ],
                                    "text": "t i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-474",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 884.5, 1884.8, 106.66666666666667, 22.0 ],
                                    "text": "gate"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-475",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "" ],
                                    "patching_rect": [ 896.5, 1816.8, 57.0, 22.0 ],
                                    "text": "sel 0 127"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-476",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 884.5, 2284.8, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-477",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 884.5, 2224.8, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-478",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 884.5, 2196.8, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-479",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 956.5, 2128.8, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-480",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 956.5, 2104.8, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-481",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 956.5, 2080.8, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-482",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 884.5, 1932.8, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-483",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 884.5, 2156.8, 93.40000081062317, 22.0 ],
                                    "text": "zl.join"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-484",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 884.5, 2012.8, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-485",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 956.5, 2048.8, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-486",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 940.5, 1972.8, 29.5, 22.0 ],
                                    "text": "16"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-487",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 884.5, 1972.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-454",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 605.5, 1848.8, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-455",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 569.5, 1848.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-456",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "int", "int" ],
                                    "patching_rect": [ 569.5, 1784.8, 93.66666666666667, 22.0 ],
                                    "text": "t i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-457",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 557.5, 1884.8, 106.66666666666667, 22.0 ],
                                    "text": "gate"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-458",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "" ],
                                    "patching_rect": [ 569.5, 1816.8, 57.0, 22.0 ],
                                    "text": "sel 0 127"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-459",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 557.5, 2284.8, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-460",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 557.5, 2224.8, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-461",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 557.5, 2196.8, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-462",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 629.5, 2128.8, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-463",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 629.5, 2104.8, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-464",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 629.5, 2080.8, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-465",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 557.5, 1932.8, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-466",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 557.5, 2156.8, 93.40000081062317, 22.0 ],
                                    "text": "zl.join"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-467",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 557.5, 2012.8, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-468",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 629.5, 2048.8, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-469",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 613.5, 1972.8, 29.5, 22.0 ],
                                    "text": "15"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-470",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 557.5, 1972.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-437",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 278.5, 1848.8, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-438",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 242.5, 1848.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-439",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "int", "int" ],
                                    "patching_rect": [ 242.5, 1784.8, 93.66666666666667, 22.0 ],
                                    "text": "t i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-440",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 230.5, 1884.8, 106.66666666666667, 22.0 ],
                                    "text": "gate"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-441",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "" ],
                                    "patching_rect": [ 242.5, 1816.8, 57.0, 22.0 ],
                                    "text": "sel 0 127"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-442",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 230.5, 2284.8, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-443",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 230.5, 2224.8, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-444",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 230.5, 2196.8, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-445",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 302.5, 2128.8, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-446",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 302.5, 2104.8, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-447",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 302.5, 2080.8, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-448",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 230.5, 1932.8, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-449",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 230.5, 2156.8, 93.40000081062317, 22.0 ],
                                    "text": "zl.join"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-450",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 230.5, 2012.8, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-451",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 302.5, 2048.8, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-452",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 286.5, 1972.8, 29.5, 22.0 ],
                                    "text": "14"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-453",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 230.5, 1972.8, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-430",
                                    "maxclass": "incdec",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 2923.076923076923, 1315.0000196099281, 20.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2536.3504472610957, 593.5897435897435, 73.07692307692308, 78.2051282051282 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-412",
                                    "maxclass": "dial",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1877.5, 1618.0000514388084, 130.0, 130.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 690.0, 572.0, 66.0, 66.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-381",
                                    "maxclass": "dial",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1550.5, 1618.0000514388084, 130.0, 130.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 600.0, 572.0, 66.0, 66.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-363",
                                    "maxclass": "dial",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1223.5, 1618.0000514388084, 130.0, 130.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 510.0, 572.0, 66.0, 66.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-277",
                                    "maxclass": "dial",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 896.5, 1618.0000514388084, 130.0, 130.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 420.0, 572.0, 66.0, 66.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "dial",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 569.5, 1618.0000514388084, 130.0, 130.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 330.0, 572.0, 66.0, 66.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-57",
                                    "maxclass": "dial",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 242.5, 1618.0000514388084, 130.0, 130.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 240.0, 572.0, 66.0, 66.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2990.000043988228, 1377.6000208854675, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-28",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2952.000043988228, 1377.6000208854675, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "int", "int" ],
                                    "patching_rect": [ 2952.000043988228, 1316.0000196099281, 93.66666666666667, 22.0 ],
                                    "text": "t i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2939.000043988228, 1413.333375453949, 106.66666666666667, 22.0 ],
                                    "text": "gate"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "" ],
                                    "patching_rect": [ 2952.000043988228, 1347.2000200748444, 57.0, 22.0 ],
                                    "text": "sel 0 127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 196.0, 49.0, 46.0, 22.0 ],
                                    "text": "route 1"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-25",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 553.7000030875206, 87.0, 81.0, 22.0 ],
                                    "text": "s ---display_2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-24",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 346.5, 87.0, 81.0, 22.0 ],
                                    "text": "s ---display_1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 553.7000030875206, 49.0, 173.0, 22.0 ],
                                    "text": "if $i1 == 2 && $i2 == 0 then $i3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 346.5, 49.0, 173.0, 22.0 ],
                                    "text": "if $i1 == 2 && $i2 == 1 then $i3"
                                }
                            },
                            {
                                "box": {
                                    "bgmode": 0,
                                    "border": 0,
                                    "clickthrough": 0,
                                    "embed": 1,
                                    "enablehscroll": 0,
                                    "enablevscroll": 0,
                                    "id": "obj-21",
                                    "lockeddragscroll": 0,
                                    "lockedsize": 0,
                                    "maxclass": "bpatcher",
                                    "name": "7 segment display to binary.maxpat",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "offset": [ 0.0, 0.0 ],
                                    "outlettype": [ "" ],
                                    "patcher": {
                                        "fileversion": 1,
                                        "appversion": {
                                            "major": 9,
                                            "minor": 2,
                                            "revision": 1,
                                            "architecture": "x64",
                                            "modernui": 1
                                        },
                                        "classnamespace": "box",
                                        "rect": [ 36.0, 196.0, 851.0, 844.0 ],
                                        "openinpresentation": 1,
                                        "boxes": [
                                            {
                                                "box": {
                                                    "comment": "",
                                                    "id": "obj-24",
                                                    "index": 1,
                                                    "maxclass": "outlet",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 71.0, 558.3000059723854, 30.0, 30.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "comment": "",
                                                    "id": "obj-47",
                                                    "index": 1,
                                                    "maxclass": "inlet",
                                                    "numinlets": 0,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 14.933334112167358, 30.0, 30.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-21",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 572.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 6"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-22",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 572.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-23",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 572.0, 117.80000168085098, 35.0, 22.0 ],
                                                    "text": "& 64"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-18",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 636.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 5"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-19",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 636.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-20",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 636.0, 117.80000168085098, 35.0, 22.0 ],
                                                    "text": "& 32"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-1",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 701.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 4"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-2",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 701.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-10",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 701.0, 117.80000168085098, 35.0, 22.0 ],
                                                    "text": "& 16"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-27",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 766.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 3"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-28",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 766.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-29",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 766.0, 117.80000168085098, 32.5, 22.0 ],
                                                    "text": "& 8"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-30",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 830.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 2"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-31",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 830.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-32",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 830.0, 117.80000168085098, 32.5, 22.0 ],
                                                    "text": "& 4"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-33",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 893.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-34",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 893.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-35",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 893.0, 117.80000168085098, 32.5, 22.0 ],
                                                    "text": "& 2"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-43",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 956.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-44",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 956.0, 117.80000168085098, 32.5, 22.0 ],
                                                    "text": "& 1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-46",
                                                    "maxclass": "number",
                                                    "maximum": 127,
                                                    "minimum": 0,
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 572.0, 58.466668248176575, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-98",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 398.40000474452984, 93.80000168085098, 140.0, 22.0 ],
                                                    "text": "if $i1 < 127 then 0 else 1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-97",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 398.40000474452984, 136.0000044107437, 41.0, 22.0 ],
                                                    "text": "set $1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-91",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "" ],
                                                    "patching_rect": [ 572.0, 329.0, 152.0, 22.0 ],
                                                    "text": "t l l"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-90",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 705.0, 396.7500036507845, 57.0, 22.0 ],
                                                    "text": "tosymbol"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-89",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 428.8000059723854, 90.0, 22.0 ],
                                                    "text": "set \"00000000\""
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-87",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 363.7000013291836, 121.0, 22.0 ],
                                                    "text": "match 0 0 0 0 0 0 0 0"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontface": 1,
                                                    "fontname": "Monaco",
                                                    "fontsize": 14.0,
                                                    "id": "obj-81",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 105.101750474048, 134.0000044107437, 93.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 105.101750474048, 133.20000234246254, 93.0, 24.0 ],
                                                    "text": "All on/off"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-80",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 398.40000474452984, 165.70000234246254, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 200.87221609605092, 133.20000234246254, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontface": 1,
                                                    "fontname": "Monaco",
                                                    "fontsize": 14.0,
                                                    "id": "obj-72",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 407.8285702041218, 578.8000059723854, 93.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 105.101750474048, 74.00000441074371, 93.0, 24.0 ],
                                                    "text": "Binary bit"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontface": 1,
                                                    "fontname": "Monaco",
                                                    "fontsize": 14.0,
                                                    "id": "obj-71",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 334.399993956089, 578.8000059723854, 83.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 105.101750474048, 18.80000102519989, 67.0, 24.0 ],
                                                    "text": "Decimal"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-67",
                                                    "maxclass": "newobj",
                                                    "numinlets": 7,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 125.60000187158585, 496.600006043911, 291.2285683325359, 22.0 ],
                                                    "text": "expr $i1 + $i2 + $i3 + $i4 + $i5 + $i6 + $i7"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-66",
                                                    "maxclass": "newobj",
                                                    "numinlets": 7,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 125.60000187158585, 464.0, 291.2285683325359, 22.0 ],
                                                    "text": "pak i i i i i i i"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-64",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 125.60000187158585, 531.8000059723854, 72.0, 22.0 ],
                                                    "text": "prepend set"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Monaco",
                                                    "id": "obj-65",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 125.39999395608902, 562.8000059723854, 67.0, 21.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 120.101750474048, 47.00000441074371, 67.0, 21.0 ],
                                                    "text": "8"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-54",
                                                    "maxclass": "newobj",
                                                    "numinlets": 8,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 705.0, 363.7000013291836, 151.0, 22.0 ],
                                                    "text": "sprintf %i%i%i%i%i%i%i%i"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-53",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 300.0, 63.0, 22.0 ],
                                                    "text": "prepend 0"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-52",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 705.0, 428.8000059723854, 72.0, 22.0 ],
                                                    "text": "prepend set"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Monaco",
                                                    "id": "obj-51",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 704.7999920845032, 474.8000059723854, 67.0, 21.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 120.101750474048, 100.00000441074371, 67.0, 21.0 ],
                                                    "text": "1000"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-49",
                                                    "maxclass": "newobj",
                                                    "numinlets": 7,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 269.0, 82.0, 22.0 ],
                                                    "text": "pak i i i i i i i"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-45",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 1196.0, 1788.0, 150.0, 20.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-42",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 397.8285702041218, 429.60000640153885, 77.0, 22.0 ],
                                                    "text": "scale 0 1 0 1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-41",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 352.4571421486991, 400.8000059723854, 77.0, 22.0 ],
                                                    "text": "scale 0 1 0 2"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-40",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 307.08571409327647, 372.00000554323196, 77.0, 22.0 ],
                                                    "text": "scale 0 1 0 4"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-39",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 261.7142860378538, 343.2000051140785, 77.0, 22.0 ],
                                                    "text": "scale 0 1 0 8"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-38",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 216.34285798243116, 314.4000046849251, 83.0, 22.0 ],
                                                    "text": "scale 0 1 0 16"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-37",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 170.9714299270085, 285.60000425577164, 83.0, 22.0 ],
                                                    "text": "scale 0 1 0 32"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-36",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 125.60000187158585, 256.8000038266182, 83.0, 22.0 ],
                                                    "text": "scale 0 1 0 64"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-17",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 117.80000168085098, 61.40000069141388, 11.799999952316284 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 96.80000168085098, 61.40000069141388, 11.799999952316284 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[15]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[6]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-16",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 39.80000102519989, 61.40000069141388, 11.799999952316284 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 18.80000102519989, 61.40000069141388, 11.799999952316284 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[2]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[5]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-15",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 197.80000269412994, 61.40000069141388, 11.799999952316284 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 176.80000269412994, 61.40000069141388, 11.799999952316284 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[3]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[4]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-14",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 170.9714299270085, 133.60000199079514, 10.999999940395355, 62.20000070333481 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 65.9714299270085, 112.60000199079514, 10.999999940395355, 62.20000070333481 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[11]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[3]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-13",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 170.9714299270085, 53.600000977516174, 10.999999940395355, 62.20000070333481 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 65.9714299270085, 32.600000977516174, 10.999999940395355, 62.20000070333481 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[12]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[2]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-12",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 53.600000977516174, 10.999999940395355, 62.20000070333481 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 32.600000977516174, 10.999999940395355, 62.20000070333481 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[13]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[1]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-11",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 133.60000199079514, 10.999999940395355, 62.20000070333481 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 112.60000199079514, 10.999999940395355, 62.20000070333481 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[14]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-9",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 398.40000474452984, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 200.87221609605092, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-8",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 352.91428978102556, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 169.893513711399, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-7",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 307.4285748175213, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 138.91481132674707, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-6",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 261.942859854017, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 107.93610894209515, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-5",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 216.45714489051275, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 76.95740655744319, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-4",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 170.9714299270085, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 45.978704172791254, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-3",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 125.48571496350425, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 196.0, 24.0, 24.0 ],
                                                    "varname": "toggle"
                                                }
                                            }
                                        ],
                                        "lines": [
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-2", 0 ],
                                                    "source": [ "obj-1", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-1", 0 ],
                                                    "source": [ "obj-10", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-8", 0 ],
                                                    "source": [ "obj-11", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-7", 0 ],
                                                    "source": [ "obj-12", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-5", 0 ],
                                                    "source": [ "obj-13", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-4", 0 ],
                                                    "source": [ "obj-14", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-9", 0 ],
                                                    "source": [ "obj-15", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-6", 0 ],
                                                    "source": [ "obj-16", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-3", 0 ],
                                                    "source": [ "obj-17", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-19", 0 ],
                                                    "source": [ "obj-18", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-4", 0 ],
                                                    "source": [ "obj-19", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-5", 0 ],
                                                    "source": [ "obj-2", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-18", 0 ],
                                                    "source": [ "obj-20", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-22", 0 ],
                                                    "source": [ "obj-21", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-3", 0 ],
                                                    "source": [ "obj-22", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-21", 0 ],
                                                    "source": [ "obj-23", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-28", 0 ],
                                                    "source": [ "obj-27", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-6", 0 ],
                                                    "source": [ "obj-28", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-27", 0 ],
                                                    "source": [ "obj-29", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-17", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-3", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-36", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-3", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 0 ],
                                                    "order": 0,
                                                    "source": [ "obj-3", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-31", 0 ],
                                                    "source": [ "obj-30", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-7", 0 ],
                                                    "source": [ "obj-31", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-30", 0 ],
                                                    "source": [ "obj-32", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-34", 0 ],
                                                    "source": [ "obj-33", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-8", 0 ],
                                                    "source": [ "obj-34", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-33", 0 ],
                                                    "source": [ "obj-35", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 0 ],
                                                    "source": [ "obj-36", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 1 ],
                                                    "source": [ "obj-37", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 2 ],
                                                    "source": [ "obj-38", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 3 ],
                                                    "source": [ "obj-39", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-14", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-4", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-37", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-4", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 1 ],
                                                    "order": 0,
                                                    "source": [ "obj-4", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 4 ],
                                                    "source": [ "obj-40", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 5 ],
                                                    "source": [ "obj-41", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 6 ],
                                                    "source": [ "obj-42", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-9", 0 ],
                                                    "source": [ "obj-43", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-43", 0 ],
                                                    "source": [ "obj-44", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-10", 0 ],
                                                    "order": 4,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-20", 0 ],
                                                    "order": 5,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-23", 0 ],
                                                    "order": 6,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-29", 0 ],
                                                    "order": 3,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-32", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-35", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-44", 0 ],
                                                    "order": 0,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-46", 0 ],
                                                    "source": [ "obj-47", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-53", 0 ],
                                                    "source": [ "obj-49", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-13", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-5", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-38", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-5", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 2 ],
                                                    "order": 0,
                                                    "source": [ "obj-5", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-51", 0 ],
                                                    "source": [ "obj-52", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-91", 0 ],
                                                    "source": [ "obj-53", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-90", 0 ],
                                                    "source": [ "obj-54", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-16", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-6", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-39", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-6", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 3 ],
                                                    "order": 0,
                                                    "source": [ "obj-6", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-65", 0 ],
                                                    "source": [ "obj-64", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-67", 0 ],
                                                    "source": [ "obj-66", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-24", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-67", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-64", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-67", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-98", 0 ],
                                                    "midpoints": [ 135.10000187158585, 528.600006043911, 63.50000330805784, 528.600006043911, 63.50000330805784, 21.0, 407.90000474452984, 21.0 ],
                                                    "order": 0,
                                                    "source": [ "obj-67", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-12", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-7", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-40", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-7", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 4 ],
                                                    "order": 0,
                                                    "source": [ "obj-7", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-11", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-8", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-41", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-8", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 5 ],
                                                    "order": 0,
                                                    "source": [ "obj-8", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-3", 0 ],
                                                    "order": 6,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-4", 0 ],
                                                    "order": 5,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-5", 0 ],
                                                    "order": 4,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-6", 0 ],
                                                    "order": 3,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-7", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-8", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-9", 0 ],
                                                    "order": 0,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-89", 0 ],
                                                    "source": [ "obj-87", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-51", 0 ],
                                                    "source": [ "obj-89", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-15", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-9", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-42", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-9", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 6 ],
                                                    "order": 0,
                                                    "source": [ "obj-9", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-52", 0 ],
                                                    "source": [ "obj-90", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-54", 0 ],
                                                    "source": [ "obj-91", 1 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-87", 0 ],
                                                    "source": [ "obj-91", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-80", 0 ],
                                                    "source": [ "obj-97", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-97", 0 ],
                                                    "source": [ "obj-98", 0 ]
                                                }
                                            }
                                        ]
                                    },
                                    "patching_rect": [ 2614.0, 341.60000509023666, 229.6000034213066, 225.60000336170197 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2284.0, 96.0, 85.599999, 193.600001 ],
                                    "viewvisibility": 1
                                }
                            },
                            {
                                "box": {
                                    "bgmode": 0,
                                    "border": 0,
                                    "clickthrough": 0,
                                    "embed": 1,
                                    "enablehscroll": 0,
                                    "enablevscroll": 0,
                                    "id": "obj-20",
                                    "lockeddragscroll": 0,
                                    "lockedsize": 0,
                                    "maxclass": "bpatcher",
                                    "name": "7 segment display to binary.maxpat",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "offset": [ 0.0, 0.0 ],
                                    "outlettype": [ "" ],
                                    "patcher": {
                                        "fileversion": 1,
                                        "appversion": {
                                            "major": 9,
                                            "minor": 2,
                                            "revision": 1,
                                            "architecture": "x64",
                                            "modernui": 1
                                        },
                                        "classnamespace": "box",
                                        "rect": [ 36.0, 196.0, 851.0, 844.0 ],
                                        "openinpresentation": 1,
                                        "boxes": [
                                            {
                                                "box": {
                                                    "comment": "",
                                                    "id": "obj-24",
                                                    "index": 1,
                                                    "maxclass": "outlet",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 71.0, 558.3000059723854, 30.0, 30.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "comment": "",
                                                    "id": "obj-47",
                                                    "index": 1,
                                                    "maxclass": "inlet",
                                                    "numinlets": 0,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 14.933334112167358, 30.0, 30.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-21",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 572.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 6"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-22",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 572.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-23",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 572.0, 117.80000168085098, 35.0, 22.0 ],
                                                    "text": "& 64"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-18",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 636.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 5"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-19",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 636.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-20",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 636.0, 117.80000168085098, 35.0, 22.0 ],
                                                    "text": "& 32"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-1",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 701.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 4"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-2",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 701.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-10",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 701.0, 117.80000168085098, 35.0, 22.0 ],
                                                    "text": "& 16"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-27",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 766.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 3"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-28",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 766.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-29",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 766.0, 117.80000168085098, 32.5, 22.0 ],
                                                    "text": "& 8"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-30",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 830.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 2"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-31",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 830.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-32",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 830.0, 117.80000168085098, 32.5, 22.0 ],
                                                    "text": "& 4"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-33",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 893.0, 150.80000168085098, 35.0, 22.0 ],
                                                    "text": ">> 1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-34",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 893.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-35",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 893.0, 117.80000168085098, 32.5, 22.0 ],
                                                    "text": "& 2"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-43",
                                                    "maxclass": "number",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 956.0, 183.80000168085098, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-44",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "patching_rect": [ 956.0, 117.80000168085098, 32.5, 22.0 ],
                                                    "text": "& 1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Arial",
                                                    "fontsize": 12.0,
                                                    "id": "obj-46",
                                                    "maxclass": "number",
                                                    "maximum": 127,
                                                    "minimum": 0,
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "bang" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 572.0, 58.466668248176575, 50.0, 22.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-98",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 398.40000474452984, 93.80000168085098, 140.0, 22.0 ],
                                                    "text": "if $i1 < 127 then 0 else 1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-97",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 398.40000474452984, 136.0000044107437, 41.0, 22.0 ],
                                                    "text": "set $1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-91",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "", "" ],
                                                    "patching_rect": [ 572.0, 329.0, 152.0, 22.0 ],
                                                    "text": "t l l"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-90",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 705.0, 396.7500036507845, 57.0, 22.0 ],
                                                    "text": "tosymbol"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-89",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 428.8000059723854, 90.0, 22.0 ],
                                                    "text": "set \"00000000\""
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-87",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 363.7000013291836, 121.0, 22.0 ],
                                                    "text": "match 0 0 0 0 0 0 0 0"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontface": 1,
                                                    "fontname": "Monaco",
                                                    "fontsize": 14.0,
                                                    "id": "obj-81",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 105.101750474048, 134.0000044107437, 93.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 105.101750474048, 133.20000234246254, 93.0, 24.0 ],
                                                    "text": "All on/off"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-80",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 398.40000474452984, 165.70000234246254, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 200.87221609605092, 133.20000234246254, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontface": 1,
                                                    "fontname": "Monaco",
                                                    "fontsize": 14.0,
                                                    "id": "obj-72",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 407.8285702041218, 578.8000059723854, 93.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 105.101750474048, 74.00000441074371, 93.0, 24.0 ],
                                                    "text": "Binary bit"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontface": 1,
                                                    "fontname": "Monaco",
                                                    "fontsize": 14.0,
                                                    "id": "obj-71",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 334.399993956089, 578.8000059723854, 83.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 105.101750474048, 18.80000102519989, 67.0, 24.0 ],
                                                    "text": "Decimal"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-67",
                                                    "maxclass": "newobj",
                                                    "numinlets": 7,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 125.60000187158585, 496.600006043911, 291.2285683325359, 22.0 ],
                                                    "text": "expr $i1 + $i2 + $i3 + $i4 + $i5 + $i6 + $i7"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-66",
                                                    "maxclass": "newobj",
                                                    "numinlets": 7,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 125.60000187158585, 464.0, 291.2285683325359, 22.0 ],
                                                    "text": "pak i i i i i i i"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-64",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 125.60000187158585, 531.8000059723854, 72.0, 22.0 ],
                                                    "text": "prepend set"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Monaco",
                                                    "id": "obj-65",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 125.39999395608902, 562.8000059723854, 67.0, 21.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 120.101750474048, 47.00000441074371, 67.0, 21.0 ],
                                                    "text": "15"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-54",
                                                    "maxclass": "newobj",
                                                    "numinlets": 8,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 705.0, 363.7000013291836, 151.0, 22.0 ],
                                                    "text": "sprintf %i%i%i%i%i%i%i%i"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-53",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 300.0, 63.0, 22.0 ],
                                                    "text": "prepend 0"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-52",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 705.0, 428.8000059723854, 72.0, 22.0 ],
                                                    "text": "prepend set"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "fontname": "Monaco",
                                                    "id": "obj-51",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 704.7999920845032, 474.8000059723854, 67.0, 21.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 120.101750474048, 100.00000441074371, 67.0, 21.0 ],
                                                    "text": "1111"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-49",
                                                    "maxclass": "newobj",
                                                    "numinlets": 7,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 572.0, 269.0, 82.0, 22.0 ],
                                                    "text": "pak i i i i i i i"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-45",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 1196.0, 1788.0, 150.0, 20.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-42",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 397.8285702041218, 429.60000640153885, 77.0, 22.0 ],
                                                    "text": "scale 0 1 0 1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-41",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 352.4571421486991, 400.8000059723854, 77.0, 22.0 ],
                                                    "text": "scale 0 1 0 2"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-40",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 307.08571409327647, 372.00000554323196, 77.0, 22.0 ],
                                                    "text": "scale 0 1 0 4"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-39",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 261.7142860378538, 343.2000051140785, 77.0, 22.0 ],
                                                    "text": "scale 0 1 0 8"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-38",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 216.34285798243116, 314.4000046849251, 83.0, 22.0 ],
                                                    "text": "scale 0 1 0 16"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-37",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 170.9714299270085, 285.60000425577164, 83.0, 22.0 ],
                                                    "text": "scale 0 1 0 32"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-36",
                                                    "maxclass": "newobj",
                                                    "numinlets": 6,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 125.60000187158585, 256.8000038266182, 83.0, 22.0 ],
                                                    "text": "scale 0 1 0 64"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-17",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 117.80000168085098, 61.40000069141388, 11.799999952316284 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 96.80000168085098, 61.40000069141388, 11.799999952316284 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[8]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[6]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-16",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 39.80000102519989, 61.40000069141388, 11.799999952316284 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 18.80000102519989, 61.40000069141388, 11.799999952316284 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[9]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[5]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-15",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 197.80000269412994, 61.40000069141388, 11.799999952316284 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 176.80000269412994, 61.40000069141388, 11.799999952316284 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[10]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[4]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-14",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 170.9714299270085, 133.60000199079514, 10.999999940395355, 62.20000070333481 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 65.9714299270085, 112.60000199079514, 10.999999940395355, 62.20000070333481 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[6]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[3]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-13",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 170.9714299270085, 53.600000977516174, 10.999999940395355, 62.20000070333481 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 65.9714299270085, 32.600000977516174, 10.999999940395355, 62.20000070333481 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[7]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[2]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-12",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 53.600000977516174, 10.999999940395355, 62.20000070333481 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 32.600000977516174, 10.999999940395355, 62.20000070333481 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle[1]",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle[1]"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "activebgcolor": [ 0.717647058823529, 0.717647058823529, 0.717647058823529, 0.0 ],
                                                    "activebgoncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                                    "bordercolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                                                    "focusbordercolor": [ 0.156862745098039, 0.156862745098039, 0.156862745098039, 0.0 ],
                                                    "id": "obj-11",
                                                    "maxclass": "live.toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "parameter_enable": 1,
                                                    "patching_rect": [ 120.00000178813934, 133.60000199079514, 10.999999940395355, 62.20000070333481 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 112.60000199079514, 10.999999940395355, 62.20000070333481 ],
                                                    "saved_attribute_attributes": {
                                                        "activebgcolor": {
                                                            "expression": ""
                                                        },
                                                        "activebgoncolor": {
                                                            "expression": ""
                                                        },
                                                        "bordercolor": {
                                                            "expression": ""
                                                        },
                                                        "focusbordercolor": {
                                                            "expression": ""
                                                        },
                                                        "valueof": {
                                                            "parameter_enum": [ "off", "on" ],
                                                            "parameter_invisible": 2,
                                                            "parameter_longname": "live.toggle",
                                                            "parameter_mmax": 1,
                                                            "parameter_modmode": 0,
                                                            "parameter_shortname": "live.toggle",
                                                            "parameter_type": 2
                                                        }
                                                    },
                                                    "varname": "live.toggle"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-9",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 398.40000474452984, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 200.87221609605092, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-8",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 352.91428978102556, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 169.893513711399, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-7",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 307.4285748175213, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 138.91481132674707, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-6",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 261.942859854017, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 107.93610894209515, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-5",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 216.45714489051275, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 76.95740655744319, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-4",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 170.9714299270085, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 45.978704172791254, 196.0, 24.0, 24.0 ]
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-3",
                                                    "maxclass": "toggle",
                                                    "numinlets": 1,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "int" ],
                                                    "parameter_enable": 0,
                                                    "patching_rect": [ 125.48571496350425, 217.0, 24.0, 24.0 ],
                                                    "presentation": 1,
                                                    "presentation_rect": [ 15.000001788139343, 196.0, 24.0, 24.0 ],
                                                    "varname": "toggle"
                                                }
                                            }
                                        ],
                                        "lines": [
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-2", 0 ],
                                                    "source": [ "obj-1", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-1", 0 ],
                                                    "source": [ "obj-10", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-8", 0 ],
                                                    "source": [ "obj-11", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-7", 0 ],
                                                    "source": [ "obj-12", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-5", 0 ],
                                                    "source": [ "obj-13", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-4", 0 ],
                                                    "source": [ "obj-14", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-9", 0 ],
                                                    "source": [ "obj-15", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-6", 0 ],
                                                    "source": [ "obj-16", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-3", 0 ],
                                                    "source": [ "obj-17", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-19", 0 ],
                                                    "source": [ "obj-18", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-4", 0 ],
                                                    "source": [ "obj-19", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-5", 0 ],
                                                    "source": [ "obj-2", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-18", 0 ],
                                                    "source": [ "obj-20", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-22", 0 ],
                                                    "source": [ "obj-21", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-3", 0 ],
                                                    "source": [ "obj-22", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-21", 0 ],
                                                    "source": [ "obj-23", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-28", 0 ],
                                                    "source": [ "obj-27", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-6", 0 ],
                                                    "source": [ "obj-28", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-27", 0 ],
                                                    "source": [ "obj-29", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-17", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-3", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-36", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-3", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 0 ],
                                                    "order": 0,
                                                    "source": [ "obj-3", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-31", 0 ],
                                                    "source": [ "obj-30", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-7", 0 ],
                                                    "source": [ "obj-31", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-30", 0 ],
                                                    "source": [ "obj-32", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-34", 0 ],
                                                    "source": [ "obj-33", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-8", 0 ],
                                                    "source": [ "obj-34", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-33", 0 ],
                                                    "source": [ "obj-35", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 0 ],
                                                    "source": [ "obj-36", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 1 ],
                                                    "source": [ "obj-37", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 2 ],
                                                    "source": [ "obj-38", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 3 ],
                                                    "source": [ "obj-39", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-14", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-4", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-37", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-4", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 1 ],
                                                    "order": 0,
                                                    "source": [ "obj-4", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 4 ],
                                                    "source": [ "obj-40", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 5 ],
                                                    "source": [ "obj-41", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-66", 6 ],
                                                    "source": [ "obj-42", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-9", 0 ],
                                                    "source": [ "obj-43", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-43", 0 ],
                                                    "source": [ "obj-44", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-10", 0 ],
                                                    "order": 4,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-20", 0 ],
                                                    "order": 5,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-23", 0 ],
                                                    "order": 6,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-29", 0 ],
                                                    "order": 3,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-32", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-35", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-44", 0 ],
                                                    "order": 0,
                                                    "source": [ "obj-46", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-46", 0 ],
                                                    "source": [ "obj-47", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-53", 0 ],
                                                    "source": [ "obj-49", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-13", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-5", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-38", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-5", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 2 ],
                                                    "order": 0,
                                                    "source": [ "obj-5", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-51", 0 ],
                                                    "source": [ "obj-52", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-91", 0 ],
                                                    "source": [ "obj-53", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-90", 0 ],
                                                    "source": [ "obj-54", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-16", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-6", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-39", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-6", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 3 ],
                                                    "order": 0,
                                                    "source": [ "obj-6", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-65", 0 ],
                                                    "source": [ "obj-64", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-67", 0 ],
                                                    "source": [ "obj-66", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-24", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-67", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-64", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-67", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-98", 0 ],
                                                    "midpoints": [ 135.10000187158585, 528.600006043911, 63.50000330805784, 528.600006043911, 63.50000330805784, 21.0, 407.90000474452984, 21.0 ],
                                                    "order": 0,
                                                    "source": [ "obj-67", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-12", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-7", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-40", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-7", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 4 ],
                                                    "order": 0,
                                                    "source": [ "obj-7", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-11", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-8", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-41", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-8", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 5 ],
                                                    "order": 0,
                                                    "source": [ "obj-8", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-3", 0 ],
                                                    "order": 6,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-4", 0 ],
                                                    "order": 5,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-5", 0 ],
                                                    "order": 4,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-6", 0 ],
                                                    "order": 3,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-7", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-8", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-9", 0 ],
                                                    "order": 0,
                                                    "source": [ "obj-80", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-89", 0 ],
                                                    "source": [ "obj-87", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-51", 0 ],
                                                    "source": [ "obj-89", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-15", 0 ],
                                                    "order": 2,
                                                    "source": [ "obj-9", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-42", 0 ],
                                                    "order": 1,
                                                    "source": [ "obj-9", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-49", 6 ],
                                                    "order": 0,
                                                    "source": [ "obj-9", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-52", 0 ],
                                                    "source": [ "obj-90", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-54", 0 ],
                                                    "source": [ "obj-91", 1 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-87", 0 ],
                                                    "source": [ "obj-91", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-80", 0 ],
                                                    "source": [ "obj-97", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-97", 0 ],
                                                    "source": [ "obj-98", 0 ]
                                                }
                                            }
                                        ]
                                    },
                                    "patching_rect": [ 2364.000035226345, 341.60000509023666, 229.6000034213066, 225.60000336170197 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2190.2253693938255, 96.24059295654297, 85.599999, 193.600001 ],
                                    "viewvisibility": 1
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-12",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 196.0, 87.0, 85.0, 22.0 ],
                                    "text": "s ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "comment": "[list] SysEx message",
                                    "id": "obj-7",
                                    "ignoreclick": 1,
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 23.0, 125.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 23.0, 86.0, 96.0, 22.0 ],
                                    "text": "r ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 160.0, 9.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "linecount": 2,
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2286.0, 715.0, 50.0, 35.0 ],
                                    "text": "0 10 0 118"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-407",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 2939.000043988228, 1814.0000540614128, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-408",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2939.000043988228, 1754.0000522732735, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-409",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2939.000043988228, 1726.0000514388084, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-403",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 3011.000046133995, 1658.0000494122505, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-404",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 3011.000046133995, 1634.0000486969948, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-405",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 3011.000046133995, 1610.000047981739, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-397",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 5984.0, 3968.0, 150.0, 20.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-384",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 2939.000043988228, 1462.0000435709953, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-385",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 2939.000043988228, 1686.0000502467155, 93.40000081062317, 22.0 ],
                                    "text": "zl.join"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-388",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2939.000043988228, 1542.0000459551811, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-392",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 3011.000046133995, 1578.0000470280647, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-393",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2995.000045657158, 1502.0000447630882, 29.5, 22.0 ],
                                    "text": "13"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-394",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2939.000043988228, 1502.0000447630882, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-345",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2364.00007045269, 287.33334189653397, 79.0, 22.0 ],
                                    "text": "r ---display_1"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-346",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2614.0, 304.25561225414276, 79.0, 22.0 ],
                                    "text": "r ---display_2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-323",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 2079.000009536743, 817.3333551883698, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-324",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 2079.000009536743, 468.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-325",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2114.6666762034097, 427.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-326",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2079.000009536743, 427.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-327",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 2079.000009536743, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1878.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-328",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2079.000009536743, 693.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-329",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2079.000009536743, 756.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-330",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2079.000009536743, 729.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-331",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2079.000009536743, 547.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-332",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2153.000009536743, 658.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-333",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 2153.000009536743, 634.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-334",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 2153.000009536743, 610.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-335",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 2153.000009536743, 586.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-336",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2136.222238536743, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "10"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-337",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2079.000009536743, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-338",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 2172.750009536743, 329.0, 140.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2050.0, 154.0, 92.0, 93.0 ],
                                    "text": "↑"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-339",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 2079.000009536743, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1878.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-340",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2177.000009536743, 223.0, 29.5, 22.0 ],
                                    "text": "10"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-341",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 2079.000009536743, 188.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-342",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2079.000009536743, 253.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-343",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2079.000009536743, 157.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-344",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 2079.000009536743, 284.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1956.0, 76.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-301",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 2258.666676402092, 1504.4000269770622, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-302",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 2258.666676402092, 1156.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-303",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2294.3333430687585, 1115.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-304",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2258.666676402092, 1115.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-305",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 2258.666676402092, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2058.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-306",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2258.666676402092, 1381.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-307",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2258.666676402092, 1444.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-308",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2258.666676402092, 1417.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-309",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2258.666676402092, 1235.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-310",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2332.666676402092, 1346.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-311",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 2332.666676402092, 1322.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-312",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 2332.666676402092, 1298.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-313",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 2332.666676402092, 1274.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-314",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2315.888905402092, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "12"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-315",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2258.666676402092, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-316",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 2352.416676402092, 1017.0, 135.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2230.0, 392.0, 135.0, 93.0 ],
                                    "text": "CTL"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-317",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 2258.666676402092, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2058.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-318",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2356.666676402092, 911.0, 29.5, 22.0 ],
                                    "text": "12"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-319",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 2258.666676402092, 876.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-320",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2258.666676402092, 941.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-321",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2258.666676402092, 845.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-322",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 2258.666676402092, 972.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2136.0, 314.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-279",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1931.666676402092, 1504.4000269770622, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-280",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 1931.666676402092, 1156.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-281",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1967.3333430687585, 1115.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-282",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1931.666676402092, 1115.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-283",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1931.666676402092, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1730.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-284",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1931.666676402092, 1381.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-285",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1931.666676402092, 1444.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-286",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1931.666676402092, 1417.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-287",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1931.666676402092, 1235.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-288",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2005.666676402092, 1346.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-289",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 2005.666676402092, 1322.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-290",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 2005.666676402092, 1298.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-291",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 2005.666676402092, 1274.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-292",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1988.888905402092, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "11"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-293",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1931.666676402092, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-294",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 2025.416676402092, 1017.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1902.0, 392.0, 70.0, 93.0 ],
                                    "text": "↓"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-295",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1931.666676402092, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1730.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-296",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 2029.666676402092, 911.0, 29.5, 22.0 ],
                                    "text": "11"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-297",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 1931.666676402092, 876.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-298",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1931.666676402092, 941.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-299",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1931.666676402092, 845.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-300",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1931.666676402092, 972.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1810.0, 314.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-266",
                                    "maxclass": "slider",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 2952.0, 365.8333682662353, 248.0000067949295, 930.6666954755783 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2448.888905402092, 79.8333798295364, 248.0000067949295, 506.0000343322754 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-156",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1759.0, 817.3333551883698, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-157",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 1759.0, 468.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-158",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1794.6666666666665, 427.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-159",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1759.0, 427.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-160",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1759.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1558.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-161",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1759.0, 693.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-162",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1759.0, 756.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-163",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1759.0, 729.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-164",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1759.0, 547.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-165",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1833.0, 658.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-166",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1833.0, 634.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-167",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1833.0, 610.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-168",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1833.0, 586.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-169",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1816.222229, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "9"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-170",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1759.0, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-171",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1852.75, 329.0, 93.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1730.0, 154.0, 93.0, 93.0 ],
                                    "text": "10"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-172",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1759.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1558.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-173",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1857.0, 223.0, 29.5, 22.0 ],
                                    "text": "9"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-174",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 1759.0, 188.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-175",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1759.0, 253.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-176",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1759.0, 157.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-177",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1759.0, 284.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1636.0, 76.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-178",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1420.0, 817.3333551883698, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-179",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 1420.0, 468.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-180",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1455.6666666666665, 427.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-181",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1420.0, 427.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-182",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1420.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1218.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-183",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1420.0, 693.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-184",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1420.0, 756.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-185",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1420.0, 729.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-186",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1420.0, 547.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-187",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1494.0, 658.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-188",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1494.0, 634.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-189",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1494.0, 610.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-190",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1494.0, 586.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-191",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1477.222229, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "8"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-192",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1420.0, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-193",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1513.75, 329.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1390.0, 154.0, 70.0, 93.0 ],
                                    "text": "9"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-194",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1420.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1218.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-195",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1518.0, 223.0, 29.5, 22.0 ],
                                    "text": "8"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-196",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 1420.0, 188.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-197",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1420.0, 253.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-198",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1420.0, 157.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-199",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1420.0, 284.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1298.0, 76.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-200",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1081.0, 817.3333551883698, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-201",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 1081.0, 468.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-202",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1116.6666666666665, 427.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-203",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1081.0, 427.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-204",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1081.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 880.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-205",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1081.0, 693.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-206",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1081.0, 756.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-207",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1081.0, 729.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-208",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1081.0, 547.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-209",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1155.0, 658.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-210",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1155.0, 634.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-211",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1155.0, 610.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-212",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1155.0, 586.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-213",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1138.222229, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-214",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1081.0, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-215",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1174.75, 329.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1052.0, 154.0, 70.0, 93.0 ],
                                    "text": "8"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-216",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1081.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 880.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-217",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1179.0, 223.0, 29.5, 22.0 ],
                                    "text": "7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-218",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 1081.0, 188.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-219",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1081.0, 253.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-220",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1081.0, 157.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-221",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1081.0, 284.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 958.0, 76.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-222",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 742.0, 817.3333551883698, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-223",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 742.0, 468.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-224",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 777.6666666666666, 427.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-225",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 742.0, 427.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-226",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 742.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 540.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-227",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 742.0, 693.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-228",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 742.0, 756.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-229",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 742.0, 729.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-230",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 742.0, 547.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-231",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 816.0, 658.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-232",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 816.0, 634.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-233",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 816.0, 610.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-234",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 816.0, 586.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-235",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 799.222229, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-236",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 742.0, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-237",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 835.75, 329.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 712.0, 154.0, 70.0, 93.0 ],
                                    "text": "7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-238",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 742.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 540.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-239",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 840.0, 223.0, 29.5, 22.0 ],
                                    "text": "6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-240",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 742.0, 188.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-241",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 742.0, 253.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-242",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 742.0, 157.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-243",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 742.0, 284.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 620.0, 76.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-244",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 403.0, 817.3333551883698, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-245",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 403.0, 468.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-246",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 438.66666666666663, 427.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-247",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 403.0, 427.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-248",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 403.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 202.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-249",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 403.0, 693.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-250",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 403.0, 756.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-251",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 403.0, 729.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-252",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 403.0, 547.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-253",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 477.0, 658.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-254",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 477.0, 634.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-255",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 477.0, 610.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-256",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 477.0, 586.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-257",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 460.22222899999997, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-258",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 403.0, 509.99999594688416, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-259",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 496.75, 329.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 374.0, 154.0, 70.0, 93.0 ],
                                    "text": "6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-260",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 403.0, 329.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 202.0, 154.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-261",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 501.0, 223.0, 29.5, 22.0 ],
                                    "text": "5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-262",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 403.0, 188.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-263",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 403.0, 253.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-264",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 403.0, 157.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-265",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 403.0, 284.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 280.0, 76.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-134",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1605.0, 1504.4000269770622, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-135",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 1605.0, 1156.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-136",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1640.6666666666665, 1115.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-137",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1605.0, 1115.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-138",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1605.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1404.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-139",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1605.0, 1381.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-140",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1605.0, 1444.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-141",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1605.0, 1417.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-142",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1605.0, 1235.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-143",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1679.0, 1346.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-144",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1679.0, 1322.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-145",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1679.0, 1298.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-146",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1679.0, 1274.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-147",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1662.222229, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-148",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1605.0, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-149",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1698.75, 1017.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1576.0, 392.0, 70.0, 93.0 ],
                                    "text": "5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-150",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1605.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1404.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-151",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1703.0, 911.0, 29.5, 22.0 ],
                                    "text": "4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-152",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 1605.0, 876.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-153",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1605.0, 941.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-154",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1605.0, 845.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-155",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1605.0, 972.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1482.0, 314.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-112",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1266.0, 1504.4000269770622, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-113",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 1266.0, 1156.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-114",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1301.6666666666665, 1115.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-115",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1266.0, 1115.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-116",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1266.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1064.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-117",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1266.0, 1381.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-118",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1266.0, 1444.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-119",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1266.0, 1417.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-120",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1266.0, 1235.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-121",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1340.0, 1346.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-122",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1340.0, 1322.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-123",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1340.0, 1298.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-124",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1340.0, 1274.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-125",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1323.222229, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-126",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1266.0, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-127",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1359.75, 1017.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1236.0, 392.0, 70.0, 93.0 ],
                                    "text": "4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-128",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1266.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1064.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-129",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1364.0, 911.0, 29.5, 22.0 ],
                                    "text": "3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-130",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 1266.0, 876.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-131",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1266.0, 941.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-132",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1266.0, 845.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-133",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1266.0, 972.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 1144.0, 314.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-90",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 927.0, 1504.4000269770622, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-91",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 927.0, 1156.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-92",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 962.6666666666666, 1115.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-93",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 927.0, 1115.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-94",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 927.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 726.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-95",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 927.0, 1381.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-96",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 927.0, 1444.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-97",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 927.0, 1417.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-98",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 927.0, 1235.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-99",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1001.0, 1346.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-100",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1001.0, 1322.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-101",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1001.0, 1298.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-102",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 1001.0, 1274.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-103",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 984.222229, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-104",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 927.0, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-105",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1020.75, 1017.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 898.0, 392.0, 70.0, 93.0 ],
                                    "text": "3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-106",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 927.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 726.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-107",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1025.0, 911.0, 29.5, 22.0 ],
                                    "text": "2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-108",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 927.0, 876.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-109",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 927.0, 941.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-110",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 927.0, 845.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-111",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 927.0, 972.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 804.0, 314.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-68",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 588.0, 1504.4000269770622, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-69",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 588.0, 1156.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-70",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 623.6666666666666, 1115.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-71",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 588.0, 1115.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-72",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 588.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 386.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-73",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 588.0, 1381.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-74",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 588.0, 1444.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-75",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 588.0, 1417.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-76",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 588.0, 1235.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-77",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 662.0, 1346.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-78",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 662.0, 1322.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-79",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 662.0, 1298.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-80",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 662.0, 1274.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-81",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 645.222229, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-82",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 588.0, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-83",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 681.75, 1017.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 558.0, 392.0, 70.0, 93.0 ],
                                    "text": "2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-84",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 588.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 386.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-85",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 686.0, 911.0, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-86",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 588.0, 876.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-87",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 588.0, 941.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-88",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 588.0, 845.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-89",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 588.0, 972.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 466.0, 314.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.968627450980392, 0.0, 1.0 ],
                                    "id": "obj-36",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 249.0, 1504.4000269770622, 98.0, 22.0 ],
                                    "text": "s ---virtual_pedal"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 249.0, 1156.0, 133.44445799999994, 22.0 ],
                                    "text": "t b b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 284.66666666666663, 1115.0, 29.5, 22.0 ],
                                    "text": "127"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 249.0, 1115.0, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "handoff": "",
                                    "hilite": 0,
                                    "id": "obj-27",
                                    "maxclass": "ubutton",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "bang", "bang", "", "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 249.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 48.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 249.0, 1381.8666754364967, 93.0, 22.0 ],
                                    "text": "join @triggers 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 249.0, 1444.8000093698502, 72.0, 22.0 ],
                                    "text": "append 247"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 249.0, 1417.066675901413, 142.0, 22.0 ],
                                    "text": "prepend 240 65 0 114 18"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 249.0, 1235.9999959468842, 133.44445799999994, 22.0 ],
                                    "text": "pack i i i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 323.0, 1346.5000637418136, 158.0, 22.0 ],
                                    "text": "if $i1 == 128 then 0 else $i1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-44",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 323.0, 1322.5000637418136, 41.0, 22.0 ],
                                    "text": "!- 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-45",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 323.0, 1298.5000637418136, 45.0, 22.0 ],
                                    "text": "% 128"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-46",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 323.0, 1274.5000637418136, 137.0, 22.0 ],
                                    "text": "zl.sum @zlmaxsize 999"
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-62",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 306.22222899999997, 1197.9999959468842, 35.77777100000003, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 249.0, 1197.9999959468842, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "fontname": "Ableton Sans Medium",
                                    "fontsize": 72.0,
                                    "id": "obj-11",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 342.75, 1017.0, 70.0, 93.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 220.0, 392.0, 70.0, 93.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 249.0, 1017.0, 75.0, 75.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 48.0, 392.0, 154.0, 154.0 ]
                                }
                            },
                            {
                                "box": {
                                    "bgcolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgcolor2": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_angle": 270.0,
                                    "bgfillcolor_autogradient": 0.0,
                                    "bgfillcolor_color": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color1": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "bgfillcolor_color2": [ 0.2, 0.2, 0.2, 1.0 ],
                                    "bgfillcolor_proportion": 0.5,
                                    "bgfillcolor_type": "color",
                                    "gradient": 1,
                                    "id": "obj-8",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 347.0, 911.0, 35.77777100000003, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 249.0, 876.0, 116.5, 22.0 ],
                                    "text": "t l b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 249.0, 941.0, 117.0, 22.0 ],
                                    "text": "if $i1 == $i3 then $i2"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.811764705882353, 0.525490196078431, 0.074509803921569, 1.0 ],
                                    "id": "obj-31",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 249.0, 845.0, 83.0, 22.0 ],
                                    "text": "r ---led_status"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "ignoreclick": 1,
                                    "maxclass": "led",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "oncolor": [ 1.0, 0.0, 0.0, 1.0 ],
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 249.0, 972.0, 24.0, 24.0 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 126.0, 314.0, 58.0, 58.0 ]
                                }
                            },
                            {
                                "box": {
                                    "angle": 270.0,
                                    "bgcolor": [ 0.396078431372549, 0.396078431372549, 0.396078431372549, 1.0 ],
                                    "id": "obj-18",
                                    "maxclass": "panel",
                                    "mode": 0,
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 2621.804278433323, 238.34584349393845, 70.67668545246124, 63.909768760204315 ],
                                    "presentation": 1,
                                    "presentation_rect": [ 2190.2253693938255, 96.99247258901596, 179.69923216104507, 199.99998223781586 ],
                                    "proportion": 0.5
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-22", 0 ],
                                    "order": 1,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-23", 0 ],
                                    "order": 0,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-35", 0 ],
                                    "order": 2,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-99", 0 ],
                                    "source": [ "obj-100", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-100", 0 ],
                                    "source": [ "obj-101", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-101", 0 ],
                                    "source": [ "obj-102", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-98", 1 ],
                                    "source": [ "obj-103", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-98", 0 ],
                                    "source": [ "obj-104", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-109", 2 ],
                                    "source": [ "obj-107", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-107", 0 ],
                                    "source": [ "obj-108", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-109", 0 ],
                                    "source": [ "obj-108", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-111", 0 ],
                                    "source": [ "obj-109", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-108", 0 ],
                                    "source": [ "obj-110", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-120", 2 ],
                                    "source": [ "obj-113", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-125", 0 ],
                                    "source": [ "obj-113", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-126", 0 ],
                                    "source": [ "obj-113", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-113", 0 ],
                                    "source": [ "obj-114", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-113", 0 ],
                                    "source": [ "obj-115", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-114", 0 ],
                                    "order": 0,
                                    "source": [ "obj-116", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-115", 0 ],
                                    "source": [ "obj-116", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-128", 0 ],
                                    "midpoints": [ 1294.1666666666667, 1102.0, 1251.4999996423721, 1102.0, 1251.4999996423721, 1006.0, 1275.5, 1006.0 ],
                                    "order": 1,
                                    "source": [ "obj-116", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-119", 0 ],
                                    "source": [ "obj-117", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-112", 0 ],
                                    "source": [ "obj-118", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-118", 0 ],
                                    "source": [ "obj-119", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-117", 0 ],
                                    "order": 1,
                                    "source": [ "obj-120", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-124", 0 ],
                                    "order": 0,
                                    "source": [ "obj-120", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-117", 1 ],
                                    "source": [ "obj-121", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-121", 0 ],
                                    "source": [ "obj-122", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-122", 0 ],
                                    "source": [ "obj-123", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-123", 0 ],
                                    "source": [ "obj-124", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-120", 1 ],
                                    "source": [ "obj-125", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-120", 0 ],
                                    "source": [ "obj-126", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-131", 2 ],
                                    "source": [ "obj-129", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-384", 0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-129", 0 ],
                                    "source": [ "obj-130", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-131", 0 ],
                                    "source": [ "obj-130", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-133", 0 ],
                                    "source": [ "obj-131", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-130", 0 ],
                                    "source": [ "obj-132", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-142", 2 ],
                                    "source": [ "obj-135", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-147", 0 ],
                                    "source": [ "obj-135", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-148", 0 ],
                                    "source": [ "obj-135", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-135", 0 ],
                                    "source": [ "obj-136", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-135", 0 ],
                                    "source": [ "obj-137", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-136", 0 ],
                                    "order": 0,
                                    "source": [ "obj-138", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-137", 0 ],
                                    "source": [ "obj-138", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-150", 0 ],
                                    "midpoints": [ 1633.1666666666667, 1102.0, 1590.4999996423721, 1102.0, 1590.4999996423721, 1006.0, 1614.5, 1006.0 ],
                                    "order": 1,
                                    "source": [ "obj-138", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-141", 0 ],
                                    "source": [ "obj-139", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "order": 1,
                                    "source": [ "obj-14", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-46", 0 ],
                                    "order": 0,
                                    "source": [ "obj-14", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-134", 0 ],
                                    "source": [ "obj-140", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-140", 0 ],
                                    "source": [ "obj-141", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-139", 0 ],
                                    "order": 1,
                                    "source": [ "obj-142", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-146", 0 ],
                                    "order": 0,
                                    "source": [ "obj-142", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-139", 1 ],
                                    "source": [ "obj-143", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-143", 0 ],
                                    "source": [ "obj-144", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-144", 0 ],
                                    "source": [ "obj-145", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-145", 0 ],
                                    "source": [ "obj-146", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-142", 1 ],
                                    "source": [ "obj-147", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-142", 0 ],
                                    "source": [ "obj-148", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "source": [ "obj-15", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-153", 2 ],
                                    "source": [ "obj-151", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-151", 0 ],
                                    "source": [ "obj-152", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-153", 0 ],
                                    "source": [ "obj-152", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-155", 0 ],
                                    "source": [ "obj-153", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-152", 0 ],
                                    "source": [ "obj-154", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-164", 2 ],
                                    "source": [ "obj-157", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-169", 0 ],
                                    "source": [ "obj-157", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-170", 0 ],
                                    "source": [ "obj-157", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-157", 0 ],
                                    "source": [ "obj-158", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-157", 0 ],
                                    "source": [ "obj-159", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 0 ],
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-158", 0 ],
                                    "order": 0,
                                    "source": [ "obj-160", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-159", 0 ],
                                    "source": [ "obj-160", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-172", 0 ],
                                    "midpoints": [ 1787.1666666666667, 414.0, 1744.4999996423721, 414.0, 1744.4999996423721, 318.0, 1768.5, 318.0 ],
                                    "order": 1,
                                    "source": [ "obj-160", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-163", 0 ],
                                    "source": [ "obj-161", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-156", 0 ],
                                    "source": [ "obj-162", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-162", 0 ],
                                    "source": [ "obj-163", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-161", 0 ],
                                    "order": 1,
                                    "source": [ "obj-164", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-168", 0 ],
                                    "order": 0,
                                    "source": [ "obj-164", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-161", 1 ],
                                    "source": [ "obj-165", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-165", 0 ],
                                    "source": [ "obj-166", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-166", 0 ],
                                    "source": [ "obj-167", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-167", 0 ],
                                    "source": [ "obj-168", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-164", 1 ],
                                    "source": [ "obj-169", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-15", 0 ],
                                    "source": [ "obj-17", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-164", 0 ],
                                    "source": [ "obj-170", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-175", 2 ],
                                    "source": [ "obj-173", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-173", 0 ],
                                    "source": [ "obj-174", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-175", 0 ],
                                    "source": [ "obj-174", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-177", 0 ],
                                    "source": [ "obj-175", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-174", 0 ],
                                    "source": [ "obj-176", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-186", 2 ],
                                    "source": [ "obj-179", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-191", 0 ],
                                    "source": [ "obj-179", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-192", 0 ],
                                    "source": [ "obj-179", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-179", 0 ],
                                    "source": [ "obj-180", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-179", 0 ],
                                    "source": [ "obj-181", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-180", 0 ],
                                    "order": 0,
                                    "source": [ "obj-182", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-181", 0 ],
                                    "source": [ "obj-182", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-194", 0 ],
                                    "midpoints": [ 1448.1666666666667, 414.0, 1405.4999996423721, 414.0, 1405.4999996423721, 318.0, 1429.5, 318.0 ],
                                    "order": 1,
                                    "source": [ "obj-182", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-185", 0 ],
                                    "source": [ "obj-183", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-178", 0 ],
                                    "source": [ "obj-184", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-184", 0 ],
                                    "source": [ "obj-185", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-183", 0 ],
                                    "order": 1,
                                    "source": [ "obj-186", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-190", 0 ],
                                    "order": 0,
                                    "source": [ "obj-186", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-183", 1 ],
                                    "source": [ "obj-187", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-187", 0 ],
                                    "source": [ "obj-188", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-188", 0 ],
                                    "source": [ "obj-189", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 1 ],
                                    "source": [ "obj-19", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "source": [ "obj-19", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-189", 0 ],
                                    "source": [ "obj-190", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-186", 1 ],
                                    "source": [ "obj-191", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-186", 0 ],
                                    "source": [ "obj-192", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-197", 2 ],
                                    "source": [ "obj-195", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-195", 0 ],
                                    "source": [ "obj-196", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-197", 0 ],
                                    "source": [ "obj-196", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-199", 0 ],
                                    "source": [ "obj-197", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-196", 0 ],
                                    "source": [ "obj-198", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-208", 2 ],
                                    "source": [ "obj-201", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-213", 0 ],
                                    "source": [ "obj-201", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-214", 0 ],
                                    "source": [ "obj-201", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-201", 0 ],
                                    "source": [ "obj-202", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-201", 0 ],
                                    "source": [ "obj-203", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-202", 0 ],
                                    "order": 0,
                                    "source": [ "obj-204", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-203", 0 ],
                                    "source": [ "obj-204", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-216", 0 ],
                                    "midpoints": [ 1109.1666666666667, 414.0, 1066.4999996423721, 414.0, 1066.4999996423721, 318.0, 1090.5, 318.0 ],
                                    "order": 1,
                                    "source": [ "obj-204", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-207", 0 ],
                                    "source": [ "obj-205", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-200", 0 ],
                                    "source": [ "obj-206", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-206", 0 ],
                                    "source": [ "obj-207", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-205", 0 ],
                                    "order": 1,
                                    "source": [ "obj-208", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-212", 0 ],
                                    "order": 0,
                                    "source": [ "obj-208", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-205", 1 ],
                                    "source": [ "obj-209", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-209", 0 ],
                                    "source": [ "obj-210", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-210", 0 ],
                                    "source": [ "obj-211", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-211", 0 ],
                                    "source": [ "obj-212", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-208", 1 ],
                                    "source": [ "obj-213", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-208", 0 ],
                                    "source": [ "obj-214", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-219", 2 ],
                                    "source": [ "obj-217", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-217", 0 ],
                                    "source": [ "obj-218", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-219", 0 ],
                                    "source": [ "obj-218", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-221", 0 ],
                                    "source": [ "obj-219", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "source": [ "obj-22", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-218", 0 ],
                                    "source": [ "obj-220", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-230", 2 ],
                                    "source": [ "obj-223", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-235", 0 ],
                                    "source": [ "obj-223", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-236", 0 ],
                                    "source": [ "obj-223", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-223", 0 ],
                                    "source": [ "obj-224", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-223", 0 ],
                                    "source": [ "obj-225", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-224", 0 ],
                                    "order": 0,
                                    "source": [ "obj-226", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-225", 0 ],
                                    "source": [ "obj-226", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-238", 0 ],
                                    "midpoints": [ 770.1666666666666, 414.0, 727.4999996423721, 414.0, 727.4999996423721, 318.0, 751.5, 318.0 ],
                                    "order": 1,
                                    "source": [ "obj-226", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-229", 0 ],
                                    "source": [ "obj-227", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-222", 0 ],
                                    "source": [ "obj-228", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-228", 0 ],
                                    "source": [ "obj-229", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "source": [ "obj-23", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-227", 0 ],
                                    "order": 1,
                                    "source": [ "obj-230", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-234", 0 ],
                                    "order": 0,
                                    "source": [ "obj-230", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-227", 1 ],
                                    "source": [ "obj-231", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-231", 0 ],
                                    "source": [ "obj-232", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-232", 0 ],
                                    "source": [ "obj-233", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-233", 0 ],
                                    "source": [ "obj-234", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-230", 1 ],
                                    "source": [ "obj-235", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-230", 0 ],
                                    "source": [ "obj-236", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-241", 2 ],
                                    "source": [ "obj-239", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-239", 0 ],
                                    "source": [ "obj-240", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-241", 0 ],
                                    "source": [ "obj-240", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-243", 0 ],
                                    "source": [ "obj-241", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-240", 0 ],
                                    "source": [ "obj-242", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-252", 2 ],
                                    "source": [ "obj-245", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-257", 0 ],
                                    "source": [ "obj-245", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-258", 0 ],
                                    "source": [ "obj-245", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-245", 0 ],
                                    "source": [ "obj-246", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-245", 0 ],
                                    "source": [ "obj-247", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-246", 0 ],
                                    "order": 0,
                                    "source": [ "obj-248", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-247", 0 ],
                                    "source": [ "obj-248", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-260", 0 ],
                                    "midpoints": [ 431.1666666666667, 414.0, 388.49999964237213, 414.0, 388.49999964237213, 318.0, 412.5, 318.0 ],
                                    "order": 1,
                                    "source": [ "obj-248", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-251", 0 ],
                                    "source": [ "obj-249", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-244", 0 ],
                                    "source": [ "obj-250", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-250", 0 ],
                                    "source": [ "obj-251", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-249", 0 ],
                                    "order": 1,
                                    "source": [ "obj-252", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-256", 0 ],
                                    "order": 0,
                                    "source": [ "obj-252", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-249", 1 ],
                                    "source": [ "obj-253", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-253", 0 ],
                                    "source": [ "obj-254", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-254", 0 ],
                                    "source": [ "obj-255", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-255", 0 ],
                                    "source": [ "obj-256", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-252", 1 ],
                                    "source": [ "obj-257", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-252", 0 ],
                                    "source": [ "obj-258", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-263", 2 ],
                                    "source": [ "obj-261", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-261", 0 ],
                                    "source": [ "obj-262", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-263", 0 ],
                                    "source": [ "obj-262", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-265", 0 ],
                                    "source": [ "obj-263", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-262", 0 ],
                                    "source": [ "obj-264", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 0 ],
                                    "order": 0,
                                    "source": [ "obj-266", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-430", 0 ],
                                    "order": 1,
                                    "source": [ "obj-266", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-32", 0 ],
                                    "order": 0,
                                    "source": [ "obj-27", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-9", 0 ],
                                    "midpoints": [ 277.1666666666667, 1102.0, 234.49999964237213, 1102.0, 234.49999964237213, 1006.0, 258.5, 1006.0 ],
                                    "order": 1,
                                    "source": [ "obj-27", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-473", 0 ],
                                    "source": [ "obj-277", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-28", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-287", 2 ],
                                    "source": [ "obj-280", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-292", 0 ],
                                    "source": [ "obj-280", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-293", 0 ],
                                    "source": [ "obj-280", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-280", 0 ],
                                    "source": [ "obj-281", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-280", 0 ],
                                    "source": [ "obj-282", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-281", 0 ],
                                    "order": 0,
                                    "source": [ "obj-283", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-282", 0 ],
                                    "source": [ "obj-283", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-295", 0 ],
                                    "midpoints": [ 1959.8333430687587, 1102.0, 1917.166676044464, 1102.0, 1917.166676044464, 1006.0, 1941.166676402092, 1006.0 ],
                                    "order": 1,
                                    "source": [ "obj-283", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-286", 0 ],
                                    "source": [ "obj-284", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-279", 0 ],
                                    "source": [ "obj-285", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-285", 0 ],
                                    "source": [ "obj-286", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-284", 0 ],
                                    "order": 1,
                                    "source": [ "obj-287", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-291", 0 ],
                                    "order": 0,
                                    "source": [ "obj-287", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-284", 1 ],
                                    "source": [ "obj-288", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-288", 0 ],
                                    "source": [ "obj-289", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "source": [ "obj-29", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-289", 0 ],
                                    "source": [ "obj-290", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-290", 0 ],
                                    "source": [ "obj-291", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-287", 1 ],
                                    "source": [ "obj-292", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-287", 0 ],
                                    "source": [ "obj-293", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-298", 2 ],
                                    "source": [ "obj-296", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-296", 0 ],
                                    "source": [ "obj-297", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-298", 0 ],
                                    "source": [ "obj-297", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-300", 0 ],
                                    "source": [ "obj-298", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-297", 0 ],
                                    "source": [ "obj-299", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-28", 0 ],
                                    "source": [ "obj-3", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-28", 0 ],
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 0 ],
                                    "source": [ "obj-3", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-309", 2 ],
                                    "source": [ "obj-302", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-314", 0 ],
                                    "source": [ "obj-302", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-315", 0 ],
                                    "source": [ "obj-302", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-302", 0 ],
                                    "source": [ "obj-303", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-302", 0 ],
                                    "source": [ "obj-304", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-303", 0 ],
                                    "order": 0,
                                    "source": [ "obj-305", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-304", 0 ],
                                    "source": [ "obj-305", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-317", 0 ],
                                    "midpoints": [ 2286.8333430687585, 1102.0, 2244.166676044464, 1102.0, 2244.166676044464, 1006.0, 2268.166676402092, 1006.0 ],
                                    "order": 1,
                                    "source": [ "obj-305", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-308", 0 ],
                                    "source": [ "obj-306", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-301", 0 ],
                                    "source": [ "obj-307", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-307", 0 ],
                                    "source": [ "obj-308", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-306", 0 ],
                                    "order": 1,
                                    "source": [ "obj-309", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-313", 0 ],
                                    "order": 0,
                                    "source": [ "obj-309", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 0 ],
                                    "source": [ "obj-31", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-306", 1 ],
                                    "source": [ "obj-310", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-310", 0 ],
                                    "source": [ "obj-311", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-311", 0 ],
                                    "source": [ "obj-312", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-312", 0 ],
                                    "source": [ "obj-313", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-309", 1 ],
                                    "source": [ "obj-314", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-309", 0 ],
                                    "source": [ "obj-315", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-320", 2 ],
                                    "source": [ "obj-318", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-318", 0 ],
                                    "source": [ "obj-319", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-320", 0 ],
                                    "source": [ "obj-319", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "source": [ "obj-32", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-322", 0 ],
                                    "source": [ "obj-320", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-319", 0 ],
                                    "source": [ "obj-321", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-331", 2 ],
                                    "source": [ "obj-324", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-336", 0 ],
                                    "source": [ "obj-324", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-337", 0 ],
                                    "source": [ "obj-324", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-324", 0 ],
                                    "source": [ "obj-325", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-324", 0 ],
                                    "source": [ "obj-326", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-325", 0 ],
                                    "order": 0,
                                    "source": [ "obj-327", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-326", 0 ],
                                    "source": [ "obj-327", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-339", 0 ],
                                    "midpoints": [ 2107.1666762034097, 414.0, 2064.5000091791153, 414.0, 2064.5000091791153, 318.0, 2088.500009536743, 318.0 ],
                                    "order": 1,
                                    "source": [ "obj-327", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-10", 1 ],
                                    "order": 0,
                                    "source": [ "obj-328", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-330", 0 ],
                                    "order": 1,
                                    "source": [ "obj-328", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-323", 0 ],
                                    "source": [ "obj-329", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 2 ],
                                    "source": [ "obj-33", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-33", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-62", 0 ],
                                    "source": [ "obj-33", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-329", 0 ],
                                    "source": [ "obj-330", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-328", 0 ],
                                    "order": 1,
                                    "source": [ "obj-331", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-335", 0 ],
                                    "order": 0,
                                    "source": [ "obj-331", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-328", 1 ],
                                    "source": [ "obj-332", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-332", 0 ],
                                    "source": [ "obj-333", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-333", 0 ],
                                    "source": [ "obj-334", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-334", 0 ],
                                    "source": [ "obj-335", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-331", 1 ],
                                    "source": [ "obj-336", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-331", 0 ],
                                    "source": [ "obj-337", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-34", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-342", 2 ],
                                    "source": [ "obj-340", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-340", 0 ],
                                    "source": [ "obj-341", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-342", 0 ],
                                    "source": [ "obj-341", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-344", 0 ],
                                    "source": [ "obj-342", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-341", 0 ],
                                    "source": [ "obj-343", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-20", 0 ],
                                    "source": [ "obj-345", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "source": [ "obj-346", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 0 ],
                                    "source": [ "obj-35", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-490", 0 ],
                                    "source": [ "obj-363", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-507", 0 ],
                                    "source": [ "obj-381", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-388", 2 ],
                                    "source": [ "obj-384", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-393", 0 ],
                                    "source": [ "obj-384", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-394", 0 ],
                                    "source": [ "obj-384", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-409", 0 ],
                                    "source": [ "obj-385", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-385", 0 ],
                                    "order": 1,
                                    "source": [ "obj-388", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-392", 0 ],
                                    "order": 0,
                                    "source": [ "obj-388", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-405", 0 ],
                                    "source": [ "obj-392", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-388", 1 ],
                                    "source": [ "obj-393", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-388", 0 ],
                                    "source": [ "obj-394", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-7", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-385", 1 ],
                                    "source": [ "obj-403", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-403", 0 ],
                                    "source": [ "obj-404", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-404", 0 ],
                                    "source": [ "obj-405", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-407", 0 ],
                                    "source": [ "obj-408", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-408", 0 ],
                                    "source": [ "obj-409", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-524", 0 ],
                                    "source": [ "obj-412", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 1 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-266", 0 ],
                                    "source": [ "obj-430", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-440", 0 ],
                                    "source": [ "obj-437", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-440", 0 ],
                                    "source": [ "obj-438", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-440", 1 ],
                                    "source": [ "obj-439", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-441", 0 ],
                                    "source": [ "obj-439", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-44", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-448", 0 ],
                                    "source": [ "obj-440", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-437", 0 ],
                                    "source": [ "obj-441", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-438", 0 ],
                                    "source": [ "obj-441", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-438", 0 ],
                                    "source": [ "obj-441", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-442", 0 ],
                                    "source": [ "obj-443", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-443", 0 ],
                                    "source": [ "obj-444", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-449", 1 ],
                                    "source": [ "obj-445", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-445", 0 ],
                                    "source": [ "obj-446", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-446", 0 ],
                                    "source": [ "obj-447", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-450", 2 ],
                                    "source": [ "obj-448", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-452", 0 ],
                                    "source": [ "obj-448", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-453", 0 ],
                                    "source": [ "obj-448", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-444", 0 ],
                                    "source": [ "obj-449", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-44", 0 ],
                                    "source": [ "obj-45", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-449", 0 ],
                                    "order": 1,
                                    "source": [ "obj-450", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-451", 0 ],
                                    "order": 0,
                                    "source": [ "obj-450", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-447", 0 ],
                                    "source": [ "obj-451", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-450", 1 ],
                                    "source": [ "obj-452", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-450", 0 ],
                                    "source": [ "obj-453", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-457", 0 ],
                                    "source": [ "obj-454", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-457", 0 ],
                                    "source": [ "obj-455", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-457", 1 ],
                                    "source": [ "obj-456", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-458", 0 ],
                                    "source": [ "obj-456", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-465", 0 ],
                                    "source": [ "obj-457", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-454", 0 ],
                                    "source": [ "obj-458", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-455", 0 ],
                                    "source": [ "obj-458", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-455", 0 ],
                                    "source": [ "obj-458", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-45", 0 ],
                                    "source": [ "obj-46", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-459", 0 ],
                                    "source": [ "obj-460", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-460", 0 ],
                                    "source": [ "obj-461", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-466", 1 ],
                                    "source": [ "obj-462", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-462", 0 ],
                                    "source": [ "obj-463", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-463", 0 ],
                                    "source": [ "obj-464", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-467", 2 ],
                                    "source": [ "obj-465", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-469", 0 ],
                                    "source": [ "obj-465", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-470", 0 ],
                                    "source": [ "obj-465", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-461", 0 ],
                                    "source": [ "obj-466", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-466", 0 ],
                                    "order": 1,
                                    "source": [ "obj-467", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-468", 0 ],
                                    "order": 0,
                                    "source": [ "obj-467", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-464", 0 ],
                                    "source": [ "obj-468", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-467", 1 ],
                                    "source": [ "obj-469", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-467", 0 ],
                                    "source": [ "obj-470", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-474", 0 ],
                                    "source": [ "obj-471", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-474", 0 ],
                                    "source": [ "obj-472", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-474", 1 ],
                                    "source": [ "obj-473", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-475", 0 ],
                                    "source": [ "obj-473", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-482", 0 ],
                                    "source": [ "obj-474", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-471", 0 ],
                                    "source": [ "obj-475", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-472", 0 ],
                                    "source": [ "obj-475", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-472", 0 ],
                                    "source": [ "obj-475", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-476", 0 ],
                                    "source": [ "obj-477", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-477", 0 ],
                                    "source": [ "obj-478", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-483", 1 ],
                                    "source": [ "obj-479", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-479", 0 ],
                                    "source": [ "obj-480", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-480", 0 ],
                                    "source": [ "obj-481", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-484", 2 ],
                                    "source": [ "obj-482", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-486", 0 ],
                                    "source": [ "obj-482", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-487", 0 ],
                                    "source": [ "obj-482", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-478", 0 ],
                                    "source": [ "obj-483", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-483", 0 ],
                                    "order": 1,
                                    "source": [ "obj-484", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-485", 0 ],
                                    "order": 0,
                                    "source": [ "obj-484", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-481", 0 ],
                                    "source": [ "obj-485", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-484", 1 ],
                                    "source": [ "obj-486", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-484", 0 ],
                                    "source": [ "obj-487", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-491", 0 ],
                                    "source": [ "obj-488", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-491", 0 ],
                                    "source": [ "obj-489", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-491", 1 ],
                                    "source": [ "obj-490", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-492", 0 ],
                                    "source": [ "obj-490", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-499", 0 ],
                                    "source": [ "obj-491", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-488", 0 ],
                                    "source": [ "obj-492", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-489", 0 ],
                                    "source": [ "obj-492", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-489", 0 ],
                                    "source": [ "obj-492", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-493", 0 ],
                                    "source": [ "obj-494", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-494", 0 ],
                                    "source": [ "obj-495", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-500", 1 ],
                                    "source": [ "obj-496", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-496", 0 ],
                                    "source": [ "obj-497", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-497", 0 ],
                                    "source": [ "obj-498", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-501", 2 ],
                                    "source": [ "obj-499", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-503", 0 ],
                                    "source": [ "obj-499", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-504", 0 ],
                                    "source": [ "obj-499", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-495", 0 ],
                                    "source": [ "obj-500", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-500", 0 ],
                                    "order": 1,
                                    "source": [ "obj-501", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-502", 0 ],
                                    "order": 0,
                                    "source": [ "obj-501", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-498", 0 ],
                                    "source": [ "obj-502", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-501", 1 ],
                                    "source": [ "obj-503", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-501", 0 ],
                                    "source": [ "obj-504", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-508", 0 ],
                                    "source": [ "obj-505", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-508", 0 ],
                                    "source": [ "obj-506", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-508", 1 ],
                                    "source": [ "obj-507", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-509", 0 ],
                                    "source": [ "obj-507", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-516", 0 ],
                                    "source": [ "obj-508", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-505", 0 ],
                                    "source": [ "obj-509", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-506", 0 ],
                                    "source": [ "obj-509", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-506", 0 ],
                                    "source": [ "obj-509", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-510", 0 ],
                                    "source": [ "obj-511", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-511", 0 ],
                                    "source": [ "obj-512", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-517", 1 ],
                                    "source": [ "obj-513", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-513", 0 ],
                                    "source": [ "obj-514", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-514", 0 ],
                                    "source": [ "obj-515", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-518", 2 ],
                                    "source": [ "obj-516", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-520", 0 ],
                                    "source": [ "obj-516", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-521", 0 ],
                                    "source": [ "obj-516", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-512", 0 ],
                                    "source": [ "obj-517", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-517", 0 ],
                                    "order": 1,
                                    "source": [ "obj-518", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-519", 0 ],
                                    "order": 0,
                                    "source": [ "obj-518", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-515", 0 ],
                                    "source": [ "obj-519", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-518", 1 ],
                                    "source": [ "obj-520", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-518", 0 ],
                                    "source": [ "obj-521", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-525", 0 ],
                                    "source": [ "obj-522", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-525", 0 ],
                                    "source": [ "obj-523", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-525", 1 ],
                                    "source": [ "obj-524", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-526", 0 ],
                                    "source": [ "obj-524", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-533", 0 ],
                                    "source": [ "obj-525", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-522", 0 ],
                                    "source": [ "obj-526", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-523", 0 ],
                                    "source": [ "obj-526", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-523", 0 ],
                                    "source": [ "obj-526", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-527", 0 ],
                                    "source": [ "obj-528", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-528", 0 ],
                                    "source": [ "obj-529", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-534", 1 ],
                                    "source": [ "obj-530", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-530", 0 ],
                                    "source": [ "obj-531", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-531", 0 ],
                                    "source": [ "obj-532", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-535", 2 ],
                                    "source": [ "obj-533", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-537", 0 ],
                                    "source": [ "obj-533", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-538", 0 ],
                                    "source": [ "obj-533", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-529", 0 ],
                                    "source": [ "obj-534", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-534", 0 ],
                                    "order": 1,
                                    "source": [ "obj-535", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-536", 0 ],
                                    "order": 0,
                                    "source": [ "obj-535", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-532", 0 ],
                                    "source": [ "obj-536", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-535", 1 ],
                                    "source": [ "obj-537", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-535", 0 ],
                                    "source": [ "obj-538", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-439", 0 ],
                                    "source": [ "obj-57", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-456", 0 ],
                                    "source": [ "obj-58", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "source": [ "obj-6", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-6", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 1 ],
                                    "source": [ "obj-62", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-76", 2 ],
                                    "source": [ "obj-69", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-81", 0 ],
                                    "source": [ "obj-69", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-82", 0 ],
                                    "source": [ "obj-69", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-69", 0 ],
                                    "source": [ "obj-70", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-69", 0 ],
                                    "source": [ "obj-71", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-70", 0 ],
                                    "order": 0,
                                    "source": [ "obj-72", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-71", 0 ],
                                    "source": [ "obj-72", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-84", 0 ],
                                    "midpoints": [ 616.1666666666666, 1102.0, 573.4999996423721, 1102.0, 573.4999996423721, 1006.0, 597.5, 1006.0 ],
                                    "order": 1,
                                    "source": [ "obj-72", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-75", 0 ],
                                    "source": [ "obj-73", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-74", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-74", 0 ],
                                    "source": [ "obj-75", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-73", 0 ],
                                    "order": 1,
                                    "source": [ "obj-76", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-80", 0 ],
                                    "order": 0,
                                    "source": [ "obj-76", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-73", 1 ],
                                    "source": [ "obj-77", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-77", 0 ],
                                    "source": [ "obj-78", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-78", 0 ],
                                    "source": [ "obj-79", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 2 ],
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-79", 0 ],
                                    "source": [ "obj-80", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-76", 1 ],
                                    "source": [ "obj-81", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-76", 0 ],
                                    "source": [ "obj-82", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-87", 2 ],
                                    "source": [ "obj-85", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-85", 0 ],
                                    "source": [ "obj-86", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-87", 0 ],
                                    "source": [ "obj-86", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-89", 0 ],
                                    "source": [ "obj-87", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-86", 0 ],
                                    "source": [ "obj-88", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-103", 0 ],
                                    "source": [ "obj-91", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-104", 0 ],
                                    "source": [ "obj-91", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-98", 2 ],
                                    "source": [ "obj-91", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-91", 0 ],
                                    "source": [ "obj-92", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-91", 0 ],
                                    "source": [ "obj-93", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-106", 0 ],
                                    "midpoints": [ 955.1666666666666, 1102.0, 912.4999996423721, 1102.0, 912.4999996423721, 1006.0, 936.5, 1006.0 ],
                                    "order": 1,
                                    "source": [ "obj-94", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-92", 0 ],
                                    "order": 0,
                                    "source": [ "obj-94", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-93", 0 ],
                                    "source": [ "obj-94", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-97", 0 ],
                                    "source": [ "obj-95", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-90", 0 ],
                                    "source": [ "obj-96", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-96", 0 ],
                                    "source": [ "obj-97", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-102", 0 ],
                                    "order": 0,
                                    "source": [ "obj-98", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-95", 0 ],
                                    "order": 1,
                                    "source": [ "obj-98", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-95", 1 ],
                                    "source": [ "obj-99", 0 ]
                                }
                            }
                        ],
                        "bgcolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                        "editing_bgcolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ]
                    },
                    "patching_rect": [ 37.0, 143.0, 87.0, 22.0 ],
                    "saved_object_attributes": {
                        "editing_bgcolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ],
                        "locked_bgcolor": [ 0.266666666666667, 0.266666666666667, 0.266666666666667, 1.0 ]
                    },
                    "text": "p virtual_pedal"
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "source": [ "obj-1", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-1", 0 ],
                    "source": [ "obj-11", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-14", 0 ],
                    "source": [ "obj-12", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-28", 0 ],
                    "source": [ "obj-14", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-11", 0 ],
                    "order": 1,
                    "source": [ "obj-2", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5", 0 ],
                    "order": 0,
                    "source": [ "obj-2", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-1", 0 ],
                    "source": [ "obj-28", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "source": [ "obj-4", 0 ]
                }
            }
        ],
        "parameters": {
            "obj-1::obj-20::obj-11": [ "live.toggle", "live.toggle", 0 ],
            "obj-1::obj-20::obj-12": [ "live.toggle[1]", "live.toggle", 0 ],
            "obj-1::obj-20::obj-13": [ "live.toggle[7]", "live.toggle", 0 ],
            "obj-1::obj-20::obj-14": [ "live.toggle[6]", "live.toggle", 0 ],
            "obj-1::obj-20::obj-15": [ "live.toggle[10]", "live.toggle", 0 ],
            "obj-1::obj-20::obj-16": [ "live.toggle[9]", "live.toggle", 0 ],
            "obj-1::obj-20::obj-17": [ "live.toggle[8]", "live.toggle", 0 ],
            "obj-1::obj-21::obj-11": [ "live.toggle[14]", "live.toggle", 0 ],
            "obj-1::obj-21::obj-12": [ "live.toggle[13]", "live.toggle", 0 ],
            "obj-1::obj-21::obj-13": [ "live.toggle[12]", "live.toggle", 0 ],
            "obj-1::obj-21::obj-14": [ "live.toggle[11]", "live.toggle", 0 ],
            "obj-1::obj-21::obj-15": [ "live.toggle[3]", "live.toggle", 0 ],
            "obj-1::obj-21::obj-16": [ "live.toggle[2]", "live.toggle", 0 ],
            "obj-1::obj-21::obj-17": [ "live.toggle[15]", "live.toggle", 0 ],
            "parameterbanks": {
                "0": {
                    "index": 0,
                    "name": "",
                    "parameters": [ "-", "-", "-", "-", "-", "-", "-", "-" ],
                    "buttons": [ "-", "-", "-", "-", "-", "-", "-", "-" ]
                }
            },
            "parameter_overrides": {
                "obj-1::obj-21::obj-11": {
                    "parameter_longname": "live.toggle[14]"
                },
                "obj-1::obj-21::obj-12": {
                    "parameter_longname": "live.toggle[13]"
                },
                "obj-1::obj-21::obj-13": {
                    "parameter_longname": "live.toggle[12]"
                },
                "obj-1::obj-21::obj-14": {
                    "parameter_longname": "live.toggle[11]"
                },
                "obj-1::obj-21::obj-15": {
                    "parameter_longname": "live.toggle[3]"
                },
                "obj-1::obj-21::obj-16": {
                    "parameter_longname": "live.toggle[2]"
                },
                "obj-1::obj-21::obj-17": {
                    "parameter_longname": "live.toggle[15]"
                }
            },
            "inherited_shortname": 1
        },
        "autosave": 0
    }
}