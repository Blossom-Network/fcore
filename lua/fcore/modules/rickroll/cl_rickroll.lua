FCore.RickRoll = {}

function FCore.RickRoll.Create()
    FCore.RickRoll.Instance = vgui.Create("DFrame")

    FCore.RickRoll.Instance:SetSize(ScrW(), ScrH())

    FCore.RickRoll.Instance:SetTitle(" ")
    FCore.RickRoll.Instance:ShowCloseButton(false)
    FCore.RickRoll.Instance:MakePopup()

    FCore.RickRoll.Instance:DockMargin(0,0,0,0)
    FCore.RickRoll.Instance:DockPadding(0,0,0,0)

    function FCore.RickRoll.Instance:Paint(w, h) return end

    FCore.RickRoll.Instance.Video = vgui.Create("DHTML", FCore.RickRoll.Instance)
    FCore.RickRoll.Instance.Video:Dock(FILL)
    FCore.RickRoll.Instance.Video:SetHTML(
        [[
            <html>
                <head>
                    <meta charset="utf-8" />
                    <style>
                        body, html {
                            margin: 0px;
                            background-color: black;

                            color: white;
                        }

                        #inner {
                            position: absolute;
                            top: 50%;
                            left: 50%;

                            width: 50%;

                            transform: translate(-50%, -50%);
                            -webkit-transform: translate(-50%, -50%);

                            text-align: center;
                        
                        }

                        h1 {
                            font-weight: 500;
                        }

                        video {
                            width: 90%;

                            border: 2px solid white;
                        }
                    </style>
                </head>
                <body>
                    <div id="inner">
                        <video src="https://fizi.pw/rickroll.ogv" autoplay loop></video>
                        <h1>zostałeś zbanowany</h1>
                    </div>
                </body>
            </html>
        ]]
    )

    timer.Simple(15, FCore.RickRoll.Destroy)
end

function FCore.RickRoll.Destroy()
    FCore.RickRoll.Instance:Close()
end