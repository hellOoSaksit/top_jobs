local Minute        = function(a) return a * 60000 end
local Second        = function(a) return a * 1000 end
local Item          = function(a, b, c) return { ItemName = a, ItemCount = b, Percent = (c) and ((c < 100) and c or 100) or false } end
local Count         = function(a, b) return { a , b or a } end
local Animation     = function(a, b, c) return { Dict = a, Name = b or false, Prop = c or false} end
local CreateNPC     = function(text, model, x, y, z, h) return { Text = text, Model = model, Position = vector3(x, y, z), Head = h} end
local CreateBlip    = function(name, id, color, scale) return { Name = name, Id = id, Color = color, Scale = scale } end
local Sound         = function(a, b) return { Name = a, Volume = b } end 
local Model         = function (a, b) return { Model = a, IsModel = b } end

----------------------
--      Config
----------------------

Config = { }
Config.ESXOLD = false -- ใช้ esx เวอชั่นอะไร 1.1 ปรับ true / 1.2 + ปรับ false
Config.ProcessBar = ''
Config.Setting = {
    AreaDistance = 50.0,
    ShowTextDistance = 6.0,
    ActionDistance = 1.5,
}

Config.Text = {
    ['press_to_start'] = "กด E เพื่อเริ่ม %s",
    ['press_to_pickup'] = "กด E เพื่อเก็บ %s",
    ['press_to_sending'] = "กด E เพื่อส่ง %s",
    ['press_to_process'] = "กด E เพื่อโพรเสซ %s",
    ['have_taken_job'] = "คุณรับงานนี้ไปแล้ว",
    ['order_max'] = "จำนวนงานที่รับได้ครบแล้ว",
    ['status_pickup'] = "ไปเก็บ %s ที่เป้าหมาย",
    ['status_sending'] = "ไปส่ง %s ที่เป้าหมาย",
    ['bag_full'] = "%s เต็มแล้ว",
    ['not_enough'] = "%s ไม่เพียงพอ",
    ['cancle_key'] = "กด X ยกเลิก"
}

-- CreateNPC("ข้อความบนหัว NPC", "โมเดล NPC", x, y, z , head)
-- CreateBlip("ข้อความ Blip", ไอดี, สี, สเกล)
-- Sound("ชื่อไฟล์เสียง", ระดับเสียง)                 ไม่ใส่เสียง ปล่อยว่างช่อง ชื่อไฟล์เสียง = Sound("", ระดับเสียง)
-- Count(1,3) = สุ่ม Count(1) ไม่สุ่ม
-- Item("ชื่อไอเท็ม", Count(จำนวน), เปอร์เซน)        เปอร์เซน ใส่ false คือได้ 100% 
-- Model("ชื่อ prop", IsModel )                   sModel ใส่ false คือ เป็น prop ใส่ true เป็น model

-- PropSetting = { 
--     MaxSpawn = 4,        จำนวน prop ที่จะ spawn        | สำคัญ   
--     Width = 6,           ระยะความกว่าที่ prop จะ spawn   | สำคัญ   
--     Delay = Second(0),   ดีเลย์การเกิด prop              | ไม่สำคัญ   
--     Movement = true ,    prop เดินได้                  | ไม่สำคัญ   
--     Attack = true,       prop โจมตีผู้เล่น               | ไม่สำคัญ   
--     Health = 130         เลือด prop                   | ไม่สำคัญ   
-- },

-------------------------
--     Rare Item Alert
------------------------
Config.RareItemAlert = {
    ["stone_diamond"] = {
        Animation   = Animation("amb@world_human_cheering@female_a", "base"),
        Sound       = Sound("", 0.1),
    },
}
-------------------------
--    END
------------------------
Config.Item = true      --โหมดสำหรับ ถ้าต้องการใช้ ไอเทมสำหรับเริ่มงาน
Config.Freeze = false   -- สำหรับเซิฟที่ต้องให้ ตอนเก็บจะโดน Freeze 
Config.disable = true   -- สำหรับเซิฟที่ต้องให้ ตอนเก็บจะโดน ปิดปุ่มเคลือนไหม รวมทั้ง SHIFT-H
Config.disableX = true  --สำหรับปิดไม่ให้กดยกเลิกได้
Config.EnableItem = false -- สำหรับเซิฟที่ต้องการให้ ต้องกดใช้ไอเทมถึงจะทำงาน
Config.Jobs = {
--------------------------------------------------------------------------------------------------------------------------------------------------------
["stone"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[🗿 หาแร่ 🗿]", "s_m_m_strvend_01", 2968.31, 2817.81, 43.75, 306.87),
            Blip        = CreateBlip("🗿 หาแร่", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "แร่",
            TimeOut     = Minute(15),
            Prop        = Model("crystal", false),
            PropSetting = { MaxSpawn = 10,  Width = 15, Movement = false,  Delay = Second(3) },
            Position    = vector3(2945.21,2788.32,40.22),
            
            Duration    = Second(8),
            --Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Animation   = Animation("melee@large_wpn@streamed_core", "ground_attack_on_spot","prop_tool_pickaxe"),
            Sound       = Sound("", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("stone", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~โพรเสซ แร่", "mp_m_weed_01", 315.21,2851.05,43.55,301.3),
            Blip        = CreateBlip("⌛ โพรเสซ แร่", 383,0, 1.0),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("stone", Count(1), false),
            },
            GetItems    = {
                Item("stone_a", Count(1,1), false),
                Item("stone_diamond", Count(1,1), 1),
                Item("stone_gold", Count(1,1), 4),
                Item("stone_copper", Count(1,1), 7),
                Item("stone_steel", Count(1,1), 8),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["shrimp"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[จับกุ้ง]", "s_m_m_strvend_01", -1535.11,-1159.04,2,95.86),
            Blip        = CreateBlip("จับกุ้ง", 387, 0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "กุ้ง",
            TimeOut     = Minute(4),
            Prop        = Model("lobsterxl", false),
            PropSetting = { MaxSpawn = 10,  Width = 17, Movement = false,  Delay = Second(3) },
            Position    = vector3(-1509.85,-1150.87,0.21),
            
            Duration    = Second(4),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("prawn", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~โพรเสซ กุ้ง", "mp_m_weed_01", -1836.71,-1208.49,14.31,150.54),
            Blip        = CreateBlip("⌛ โพรเสซ กุ้ง", 387, 0, 1.0),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("cooking", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("prawn", Count(2), false),
            },
            GetItems    = {
                Item("prawn_a", Count(1,1), false),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["shellfish"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[เก็บหอย]", "s_m_m_strvend_01", 1530.19,6617,2.32,19.18),
            Blip        = CreateBlip("เก็บหอย", 384, 0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "หอย",
            TimeOut     = Minute(4),
            Prop        = Model("slow_propjob_shell", false),
            PropSetting = { MaxSpawn = 6,  Width = 10, Movement = false,  Delay = Second(3) },
            Position    = vector3(1523.68,6627.38,2.49),
            
            Duration    = Second(4),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("shellfish", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~โพรเสซ หอย", "mp_m_weed_01", -1920.92,2052.98,140.73,258.73),
            Blip        = CreateBlip("⌛ โพรเสซ หอย", 384, 0, 1.0),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("cooking", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("shellfish", Count(2), false),
            },
            GetItems    = {
                Item("shellfish_a", Count(1,1), false),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["orange"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[🍊 เก็บส้ม 🍊]", "s_m_m_strvend_01", 253.02,6460.29,31.25,7.73),
            Blip        = CreateBlip("🍊 เก็บส้ม", 385, 0, 1.5),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "🍊 ส้ม 🍊",
            TimeOut     = Minute(4),
            Prop        = Model("orangejob", false),
            PropSetting = { MaxSpawn = 7,  Width = 14, Movement = false,  Delay = Second(3) },
            Position    = vector3(253.02,6460.29,31.25),
            
            Duration    = Second(4),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("orange", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~🍊 โพรเสซ ส้ม 🍊", "mp_m_weed_01", -1921.88,2048.96,140.73,258.73),
            Blip        = CreateBlip("⌛🍊 โพรเสซ ส้ม",385, 0, 1.5),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("orange", Count(2), false),
            },
            GetItems    = {
                Item("orange_a", Count(1,1), false),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["treelove"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[❤️ ตัดไม้หัวใจ ❤️]", "s_m_m_strvend_01", -1632.05,4737.73,53.3,313.32),
            Blip        = CreateBlip("❤️ ตัดไม้หัวใจ", 389,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "❤️ ตัดไม้หัวใจ ❤️",
            TimeOut     = Minute(4),
            Prop        = Model("tree_love", false),
            PropSetting = { MaxSpawn = 8,  Width = 17, Movement = false,  Delay = Second(3) },
            Position    = vector3(-1632.05,4737.73,53.3),
            
            Duration    = Second(4),
            --Animation   = Animation("amb@world_human_hammering@male@base", "base", "prop_ld_fireaxe"),
            Animation   = Animation("amb@world_human_hammering@male@base", "base"),
            Sound       = Sound("", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("treelove", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~โพรเสซ ไม้หัวใจ", "mp_m_weed_01", -1922.97,2044.62,140.73,258.73),
            Blip        = CreateBlip("⌛❤️ โพรเสซ ไม้หัวใจ",389,0, 1.0),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("treelove", Count(2), false),
            },
            GetItems    = {
                Item("treelove_a", Count(1,1), false),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["mushroom"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[🍄 เก็บเห็ด 🍄]", "s_m_m_strvend_01", -2583.14, 2464.14, 2.97, 10.87),
            Blip        = CreateBlip("🍄 เก็บเห็ด", 386, 0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "🍄 เก็บเห็ด 🍄",
            TimeOut     = Minute(4),
            Prop        = Model("mushroomjob", false),
            PropSetting = { MaxSpawn = 5,  Width = 17, Movement = false,  Delay = Second(3) },
            Position    = vector3(-2579.46,2489.31,1.19),
            
            Duration    = Second(4),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("mushroom", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~ 🍄โพรเสซ เห็ด 🍄", "mp_m_weed_01", -1923.94,2040.62,140.73,258.73),
            Blip        = CreateBlip("⌛🍄 โพรเสซ เห็ด ", 386, 0, 1.0),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("mushroom", Count(2), false),
            },
            GetItems    = {
                Item("mushroom_pack", Count(1,1), false),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["Chiba"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[🐶 ให้อาหารสุนัข 🐶]", "s_m_m_strvend_01", 1440.48,1111.65,114.23,89.08),
            Blip        = CreateBlip("🐶 ให้อาหารสุนัข", 381, 0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "🐶 ให้อาหารสุนัข 🐶",
            TimeOut     = Minute(4),
            Prop        = Model("legend_3", false),
            PropSetting = { MaxSpawn = 5,  Width = 10, Movement = false,  Delay = Second(3) },
            Position    = vector3(1461.34,1112.72,114.33),
            
            Duration    = Second(4),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("dog", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("dog", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~🐶 โพรเสซ สุนัข 🐶", "mp_m_weed_01", -1909.03,2072.12,140.39,138.56),
            Blip        = CreateBlip("⌛🐶 โพรเสซ สุนัข", 381, 0, 1.0),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("dog", Count(2), false),
            },
            GetItems    = {
                Item("dog_b", Count(1,1), false),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["cow"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[🐄 นมวัว 🐄]", "s_m_m_strvend_01", 2383.71,5031.48,45.9,314.19),
            Blip        = CreateBlip("🐄 นมวัว", 382, 0, 1.5),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "🐄 นมวัว 🐄",
            TimeOut     = Minute(4),
            Prop        = Model("cow_2", false),
            PropSetting = { MaxSpawn = 5,  Width = 6, Movement = false,  Delay = Second(3) },
            Position    = vector3(2379.19,5055.02,46.44),
            
            Duration    = Second(4),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("cow", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("cow", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~🐄 นมวัว 🐄", "mp_m_weed_01", -1911.74,2073.91,140.39,139.4),
            Blip        = CreateBlip("⌛🐄 โพรเสซ นมวัว", 382, 0, 1.5),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("cow", Count(2), false),
            },
            GetItems    = {
                Item("cow_a", Count(1,1), false),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["durian"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[ทุเรียน]", "s_m_m_strvend_01", 2818.82,4701.19,46.36,185.12),
            Blip        = CreateBlip("ทุเรียน", 388, 0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "ทุเรียน",
            TimeOut     = Minute(4),
            Prop        = Model("wk_durian", false),
            PropSetting = { MaxSpawn = 6,  Width = 17, Movement = false,  Delay = Second(3) },
            Position    = vector3(2816.66,4724.71,46.6),
            
            Duration    = Second(4),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("MagicWand", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("durian", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~ ทุเรียน ", "mp_m_weed_01", -1924.81,2036.44,140.73,253.73),
            Blip        = CreateBlip("⌛ โพรเสซ ทุเรียน", 388, 0, 1.0),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("durian", Count(2), false),
            },
            GetItems    = {
                Item("durian_a", Count(1,1), false),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["bee"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[🐝 เก็บรังผึง 🐝]", "s_m_m_strvend_01", -649.59,5468.93,53.99,36.89),
            Blip        = CreateBlip("🐝 เก็บรังผึง", 400, 0, 1.5),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "🐝 เก็บรังผึง 🐝",
            TimeOut     = Minute(4),
            Prop        = Model("wk_honey", false),
            PropSetting = { MaxSpawn = 6,  Width = 17, Movement = false,  Delay = Second(3) },
            Position    = vector3(-655.69,5478.5,51.61),
            
            Duration    = Second(4),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("bee", Count(1,2), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~🐝 เก็บรังผึง 🐝", "mp_m_weed_01", -1920.31,2056.92,140.74,252.8),
            Blip        = CreateBlip("⌛🐝 โพรเสซ เก็บรังผึง", 400, 0, 1.5),
            
            Duration    = Second(5),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("bee", Count(2), false),
            },
            GetItems    = {
                Item("bee_a", Count(1,1), false),
            }
        }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
["Robot"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[🤖 แยกชิ้นส่วน 🤖]", "s_m_m_strvend_01", 2436.47,3110.79,48.25,271.13),
            Blip        = CreateBlip("🤖 แยกชิ้นส่วน", 20, 0, 1.5),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "🤖 แยกชิ้นส่วน 🤖",
            TimeOut     = Minute(4),
            Prop        = Model("boot3", false),
            PropSetting = { MaxSpawn = 6,  Width = 20, Movement = false,  Delay = Second(3) },
            Position    = vector3(2399.82,3091.79,48.15),
            
            Duration    = Second(4),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("", 0.1),
            UserItem    = "water", --จะมีผลก็ต่อเมือ ปรับ Config.Item = true  เท่านั้น
            GetItems    = {
                Item("steel", Count(1,2), false),
                Item("steel_a", Count(1,2), 2),
            }
        },
         -- จุดโพรเสซ
                Process = {
                    NPC         = CreateNPC("~n~ 🤖 แยกชิ้นส่วน 🤖 ", "mp_m_weed_01", -1904.16,2068.34,140.84,134.63),
                    Blip        = CreateBlip("⌛🤖 โพรเสซ แยกชิ้นส่วน", 400, 0, 1.5),
                    
                    Duration    = Second(5),
                    Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
                    Sound       = Sound("", 0.1),
        
                    AutoProcess = true,
                    RemoveItems = {
                        Item("steel", Count(2), false),
                    },
                    GetItems    = {
                        Item("steel_x", Count(1,1), false),
                    }
                }
    }
},
--------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
--[[    ["shell_a"] = {
        Mode = 2,
        ModeSetting = {
             -- จุดกดเริ่มงาน
            Start = {
                NPC = CreateNPC("หอยเชลสด", "a_m_y_beach_03", 1732.64, 95.47, 170.89, 89.3),
                Blip = CreateBlip("เก็บหอยเชลสด", 535, 2, 1.0),
            },

            -- จุดงาน
            Pickup = {
                Text        = "หอยเชลสด",
                TimeOut     = Minute(1),
                Prop        = Model("prop_conc_sacks_02a", false),
                Blip        = CreateBlip("เก็บหอยเชลสด", 535, 2, 1.0),
                Position    = {
                    vector3(1721.55, -100.63, 178.03),
                    vector3(1674.00, -65.75, 173.74),
                    vector3(1668.79, -24.08, 173.77)
                },

                Duration    = Second(5),
                Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
                Sound       = Sound("Nope", 0.1),

                GetItems    = {
                    Item("shell_a", Count(1), false),
                    Item("shell_b", Count(1,3), 50),
                }
            },
        }
    }
]]
}