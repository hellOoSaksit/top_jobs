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
Config.ESXOld = false --ถ้า ระบบ Limit ปรับ true | Weight ปรับ false

Config.MoneyTaxPay = true --ระบบหักภาษีเมือทำงาน

Config.Setting = {
    AreaDistance = 100.0,
    ShowTextDistance = 6.0,
    ActionDistance = 2,
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
-- MoneyTax                                     จำนวนเงินที่ผู้เล่นจะต้องเสียภาษาเพือทำงาน
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

Config.Jobs = {
--------------------------------------------------------------------------------------------------------------------------------------------------------
["stone"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[หาแร่]", "s_m_m_strvend_01", 2968.31, 2817.81, 43.75, 306.87),
            Blip        = CreateBlip("🗿 หาแร่", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "แร่",
            TimeOut     = Minute(15),
            Prop        = Model("stone_rca_001", false),
            PropSetting = { MaxSpawn = 10,  Width = 15, Movement = false,  Delay = Second(3) },
            Position    = vector3(2945.21,2788.32,40.22),
            
            Duration    = Second(2),
            Animation   = Animation("mining@stornbot@head_000_r", "head_000_r"),
            --Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Sound       = Sound("", 0.1),
            Moneytex    = 10,   --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                Item("puzzle_stone", Count(1,3), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~โพรเสซ แร่", "mp_m_weed_01", 315.21,2851.05,43.55,301.3),
            Blip        = CreateBlip("โพรเสซ แร่", 383,0, 1.0),
            
            Duration    = Second(3),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("puzzle_stone", Count(1), false),
            },

            
            GetItems    = {
                Item("grout", Count(1,2), false),
                Item("copper_stone", Count(1,1), 8),
                Item("gold_stone", Count(1,1), 4),
                Item("diamond", Count(1,1), 3),
            }
        }
    }
},
------------------------------------------------------------------------------------------------------------------------------------------------
["oil"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[น้ำมัน]", "s_m_m_strvend_01",607.28,2862.18,39.99,339.49),
            Blip        = CreateBlip("เก็บน้ำมัน", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "เก็บน้ำมัน",
            TimeOut     = Minute(15),
            Prop        = Model("rca_tank_001", false),
            PropSetting = { MaxSpawn = 10,  Width = 15, Movement = false,  Delay = Second(3) },
            Position    = vector3(600.24,2898.79,39.96),
            
            Duration    = Second(2),
            --Animation   = Animation("mining@stornbot@head_000_r", "head_000_r"),
            Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Sound       = Sound("", 0.1),
            Moneytex    = 10,   --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                Item("crude_oil", Count(1,3), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~โพรเสซ น้ำมัน", "mp_m_weed_01", 597.26,2929.02,40.92,43.78),
            Blip        = CreateBlip("โพรเสซ น้ำมัน", 383,0, 1.0),
            
            Duration    = Second(3),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("crude_oil", Count(1), false),
            },

            
            GetItems    = {
                Item("engine_oil", Count(1,1), false),
                Item("oil", Count(1,1), 2),
            }
        }
    }
},
------------------------------------------------------------------------------------------------------------------------------------------------
["deer"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[ฆ่ากวาง]", "s_m_m_strvend_01",-1364.26,4451.22,24.62),
            Blip        = CreateBlip("ฆ่ากวาง", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "ฆ่ากวาง",
            TimeOut     = Minute(15),
            Prop        = Model("a_c_deer", true),
            PropSetting = { MaxSpawn = 3,  Width = 15, Movement = true,  Delay = Second(1), Health = 110, Attack = true , Waepons = "weapon_musket" , Amm = 10},
            Position    = vector3(-1376.85,4397.48,36.53),
            Duration    = Second(2),
            --Animation   = Animation("mining@stornbot@head_000_r", "head_000_r"),
            Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Sound       = Sound("", 0.1),
            Moneytex    = 10,   --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                Item("deer_carcass", Count(1,3), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~ชำแหละเนื้อกวาง", "mp_m_weed_01", -1337.17,4416.93,30.49,68.38),
            Blip        = CreateBlip("ชำแหละเนื้อกวาง", 383,0, 1.0),
            
            Duration    = Second(3),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("deer_carcass", Count(1), false),
            },

            
            GetItems    = {
                Item("venison", Count(1,1), false),
                Item("antler", Count(1,1), 50),
            }
        }
    }
},
------------------------------------------------------------------------------------------------------------------------------------------------
["wood"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[ตัดไม้]", "s_m_m_strvend_01",-727.97,5374.74,58.5,63.03),
            Blip        = CreateBlip("ตัดไม้", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "รับงานตัดไม้",
            TimeOut     = Minute(15),
            Prop        = Model("rca_tree_001", false),
            PropSetting = { MaxSpawn = 10,  Width = 15, Movement = false,  Delay = Second(3) },
            Position    = vector3(-712.76,5364.35,62.72),
            
            Duration    = Second(2),
            --Animation   = Animation("mining@stornbot@head_000_r", "head_000_r"),
            Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Sound       = Sound("", 0.1),
            Moneytex    = 10,   --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                Item("wood", Count(1,3), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~แปรรูป ไม้", "mp_m_weed_01", -799.02,5399.13,34.29,10.26),
            Blip        = CreateBlip("แปรรูป ไม้", 383,0, 1.0),
            
            Duration    = Second(3),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("wood", Count(1), false),
            },

            
            GetItems    = {
                Item("plywood", Count(1,2), false),
            }
        }
    }
},
------------------------------------------------------------------------------------------------------------------------------------------------
["kratom"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[เก็บใบกระท่อม]", "s_m_m_strvend_01",2532.74,4782.2,34.69,163.95),
            Blip        = CreateBlip("เก็บใบกระท่อม", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "เก็บใบกระท่อม",
            TimeOut     = Minute(15),
            Prop        = Model("rca_kratom_001", false),
            PropSetting = { MaxSpawn = 10,  Width = 15, Movement = false,  Delay = Second(3) },
            Position    = vector3(2522.98,4825.27,34.36),
            
            Duration    = Second(2),
            --Animation   = Animation("mining@stornbot@head_000_r", "head_000_r"),
            Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Sound       = Sound("", 0.1),
            Moneytex    = 10,   --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                Item("kratom_leaves", Count(1,3), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~แปรรูป ใบกระท่อม", "mp_m_weed_01", 2506.64,4799.1,34.65,237.69),
            Blip        = CreateBlip("แปรรูป ใบกระท่อม", 383,0, 1.0),
            
            Duration    = Second(3),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("kratom_leaves", Count(1), false),
            },

            
            GetItems    = {
                Item("hut_water", Count(1,2), false),
                Item("hut_waste", Count(1,2), 30),
            }
        }
    }
},
------------------------------------------------------------------------------------------------------------------------------------------------
["scrap"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[เศษเหล็ก]", "s_m_m_strvend_01",2383.38,3117.39,48.2,65.48),
            Blip        = CreateBlip("เศษเหล็ก", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "แยกชิ้นส่วนเหล็ก",
            TimeOut     = Minute(15),
            Prop        = Model("rca_scrap_001", false),
            PropSetting = { MaxSpawn = 10,  Width = 15, Movement = false,  Delay = Second(3) },
            Position    = vector3(2402.97,3106.44,48.27),
            
            Duration    = Second(2),
            --Animation   = Animation("mining@stornbot@head_000_r", "head_000_r"),
            Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Sound       = Sound("", 0.1),
            Moneytex    = 10,   --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                Item("scrap", Count(1,3), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~แลกเศษเหล็ก", "mp_m_weed_01", 2362.86,3124.74,48.22,259.18),
            Blip        = CreateBlip("แลกชิ้นส่วนเศษเหล็ก", 383,0, 1.0),
            
            Duration    = Second(3),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("scrap", Count(1), false),
            },

            
            GetItems    = {
                Item("iron_ingot", Count(1), false),
            }
        }
    }
},
------------------------------------------------------------------------------------------------------------------------------------------------
["mango"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[เก็บมะม่วง]", "s_m_m_strvend_01",2820.55,4695.24,46.4,186.37),
            Blip        = CreateBlip("เก็บมะม่วง", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "เก็บมะม่วง",
            TimeOut     = Minute(15),
            Prop        = Model("rca_mango_001", false),
            PropSetting = { MaxSpawn = 10,  Width = 15, Movement = false,  Delay = Second(3) },
            Position    = vector3(2819.77,4728,46.73),
            
            Duration    = Second(2),
            --Animation   = Animation("mining@stornbot@head_000_r", "head_000_r"),
            Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Sound       = Sound("", 0.1),
            Moneytex    = 10,   --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                Item("mango", Count(1,3), false),
            }
        },

        -- -- จุดโพรเสซ
        -- Process = {
        --     NPC         = CreateNPC("~n~ส่งมะม่วง", "mp_m_weed_01", 2772.05,4744.22,45.81,279.33),
        --     Blip        = CreateBlip("ส่งมะม่วง", 383,0, 1.0),
            
        --     Duration    = Second(3),
        --     Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
        --     Sound       = Sound("", 0.1),

        --     AutoProcess = true,
        --     RemoveItems = {
        --         Item("mango", Count(1), false),
        --     },

            
        --     GetItems    = {
        --         Item("iron_ingot", Count(1), false),
        --     }
        -- }
    }
},
------------------------------------------------------------------------------------------------------------------------------------------------
["garbage"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[เก็บขยะ]", "s_m_m_strvend_01",1465.59,6367.59,23.71,266.18),
            Blip        = CreateBlip("เก็บขยะ", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "เก็บขยะ",
            TimeOut     = Minute(15),
            Prop        = Model("rca_dustin_001", false),
            PropSetting = { MaxSpawn = 10,  Width = 15, Movement = false,  Delay = Second(3) },
            Position    = vector3(1463.43,6354.21,23.83),
            
            Duration    = Second(2),
            --Animation   = Animation("mining@stornbot@head_000_r", "head_000_r"),
            Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Sound       = Sound("", 0.1),
            Moneytex    = 10,   --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                Item("garbage_bag", Count(1,3), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~ส่งขายขยะ", "mp_m_weed_01", 1508.45,6327.29,24.03,64.08),
            Blip        = CreateBlip("ส่งขายขยะ", 383,0, 1.0),
            
            Duration    = Second(3),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("garbage_bag", Count(1), false),
            },

            
            GetItems    = {
                Item("paper_crate", Count(1), false),
                Item("plastic_bottle", Count(1), 10),
                Item("glass_bottle", Count(1), 10),
            }
        }
    }
},
------------------------------------------------------------------------------------------------------------------------------------------------
["rubber"] = {
    Mode = 1,
    ModeSetting = {
        -- จุดกดเริ่มงาน
        Start = {
            NPC         = CreateNPC("~n~[ตกหมึก]", "s_m_m_strvend_01",2145.7,3910.11,31.07,168.44),
            Blip        = CreateBlip("ตกหมึก", 383,0, 1.0),
            Sound       = Sound("hello", 0.1),
        },

        -- จุดงาน
        Pickup = {
            Text        = "ตกหมึก",
            TimeOut     = Minute(15),
            Prop        = Model("rca_squid_001", false),
            PropSetting = { MaxSpawn = 10,  Width = 15, Movement = false,  Delay = Second(3) },
            Position    = vector3(2147.72,3918.52,30.19),
            
            Duration    = Second(2),
            --Animation   = Animation("mining@stornbot@head_000_r", "head_000_r"),
            Animation   = Animation("WORLD_HUMAN_CONST_DRILL"),
            Sound       = Sound("", 0.1),
            Moneytex    = 10,   --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                Item("squid", Count(1,3), false),
            }
        },

        -- จุดโพรเสซ
        Process = {
            NPC         = CreateNPC("~n~ส่งหมึก", "mp_m_weed_01", 1955.54,3843.88,32.02,298.42),
            Blip        = CreateBlip("ส่งหมึก", 383,0, 1.0),
            
            Duration    = Second(3),
            Animation   = Animation("rcmbarry", "bar_1_attack_idle_aln"),
            Sound       = Sound("", 0.1),

            AutoProcess = true,
            RemoveItems = {
                Item("squid", Count(1), false),
            },

            
            GetItems    = {
                Item("squid_ink", Count(1), false),
            }
        }
    }
},
------------------------------------------------------------------------------------------------------------------------------------------------
["Devil_Coin"] = {
    Mode = 2,
    ModeSetting = {
         -- จุดกดเริ่มงาน
        Start = {
            NPC = CreateNPC("Hunter", "a_m_y_beach_03", 304.91, 2633.23,44.42,99.26),
            Blip = CreateBlip("Devil Coin", 535, 2, 1.0),
            MoneyTex    = 10,
        },

        -- จุดงาน
        Pickup = {
            Text        = "รับเควส",
            TimeOut     = Minute(1),
            Prop        = Model(`proplootbox`, false),
            Blip        = CreateBlip("Devil Box", 535, 2, 1.0),
            Position    = {
                vector3(900.74,2697.46,40.86),
                -- vector3(-390.6, -726.37, 36.09),
                -- vector3(-431.56, -651.9, 37.26)
            },
            Duration    = Second(5),
            Animation   = Animation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"),
            Sound       = Sound("Nope", 0.1),
            Moneytex    = 10, --Config.MoneyTaxPay ปรับ = true ถึงทำงาน
            GetItems    = {
                -- Item("devil_coin", Count(1), false),
                Item("devil_coin", Count(1,3), false),
            }
        },
    }
},

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