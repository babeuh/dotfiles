import Graphics.X11.ExtraTypes.XF86
  ( xF86XK_AudioLowerVolume,
    xF86XK_AudioMute,
    xF86XK_AudioRaiseVolume,
  )
import XMonad
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.InsertPosition (Focus (Newer), Position (End), insertPosition)
import XMonad.Hooks.ManageDocks (AvoidStruts, avoidStruts, docks, manageDocks)
import XMonad.Hooks.ManageHelpers (doFullFloat)
import XMonad.Layout.Accordion (Accordion (Accordion))
import XMonad.Layout.Gaps
  ( Direction2D (D, L, R, U),
    GapMessage (ModifyGaps, ToggleGaps),
    GapSpec,
    Gaps,
    gaps,
  )
import XMonad.Layout.Grid (Grid (Grid, GridRatio))
import XMonad.Layout.LayoutModifier (ModifiedLayout (ModifiedLayout))
import XMonad.Layout.MultiToggle
  ( EOT,
    HCons,
    MultiToggle,
    Toggle (Toggle),
    mkToggle,
    single,
  )
import XMonad.Layout.MultiToggle.Instances (StdTransformers (FULL))
import XMonad.Layout.NoBorders
  ( Ambiguity (OnlyScreenFloat),
    ConfigurableBorder,
    lessBorders,
  )
import XMonad.Layout.PerScreen (PerScreen, ifWider)
import XMonad.Layout.Spacing
  ( Border (Border),
    Spacing (Spacing),
    bottom,
    decWindowSpacing,
    incWindowSpacing,
    left,
    right,
    screenBorder,
    screenBorderEnabled,
    smartBorder,
    toggleWindowSpacingEnabled,
    top,
    windowBorder,
    windowBorderEnabled,
  )
import XMonad.Layout.ThreeColumns (ThreeCol (ThreeCol, threeColDelta, threeColFrac, threeColNMaster))
import XMonad.Layout.TwoPanePersistent (TwoPanePersistent (TwoPanePersistent, dFrac, mFrac, slaveWin))
import XMonad.StackSet
  ( RationalRect (RationalRect),
    current,
    focusMaster,
    greedyView,
    layout,
    shift,
    workspace,
  )
import XMonad.Layout.BinarySpacePartition (emptyBSP, BinarySpacePartition)
import XMonad.Util.EZConfig (additionalKeys, removeKeys)
import XMonad.Util.NamedScratchpad
  ( NamedScratchpad (NS),
    cmd,
    customFloating,
    hook,
    name,
    namedScratchpadAction,
    namedScratchpadManageHook,
    query,
  )

main :: IO ()
main = xmonad myConfig

myConfig :: XConfig (MyLayoutModifiers MyTogglableLayouts)
myConfig =
  docks
    . ewmh
    . ewmhFullscreen
    $ def
      { terminal = myTerminal,
        manageHook = myManageHook,
        layoutHook = myLayoutModifiers myTogglableLayouts,
        handleEventHook = handleEventHook def,
        -- NOTE: Injected using nix strings.
        -- Think about parsing colorscheme.nix file in some way
        --focusedBorderColor = myFocusedBorderColor,
        --normalBorderColor = myNormalBorderColor,
        borderWidth = 3
      }
      -- NOTE: Ordering matters here
      `additionalKeys` keysToAdd

myModMask :: KeyMask
myModMask = mod4Mask

myTerminal :: String
myTerminal = "alacritty"

keysToAdd :: [((KeyMask, KeySym), X ())]
keysToAdd = launchers ++ multimediaKeys ++ layoutRelated
  where
    launchers =
      [ ( (myModMask, xK_space),
          spawn "rofi -show drun -theme grid"
        ),
        ( (myModMask, xK_w), kill),
        ( (myModMask, xK_Return),
          spawn $ myTerminal
        ),
        ( (myModMask .|. shiftMask, xK_l),
          spawn "betterlockscreen --wall --blur -l"
        ),
        ( (myModMask .|. shiftMask, xK_n),
          spawn "kill -s USR1 $(pidof deadd-notification-center)"
        ),
        ( (myModMask .|. shiftMask, xK_s),
          spawn "scrot -s ~/Pictures/screenshots/scrot_%Y-%m-%d-%H%M%S.png"
        )
      ]

    multimediaKeys =
      [ ((0, xF86XK_AudioLowerVolume), spawn "amixer sset Master 5%-"),
        ((0, xF86XK_AudioRaiseVolume), spawn "amixer sset Master 5%+"),
        ((0, xF86XK_AudioMute), spawn "amixer sset Master toggle")
      ]
    layoutRelated =
      [ ((myModMask, xK_n), sendMessage NextLayout),
        ((myModMask, xK_m), sendMessage $ Toggle FULL),
        ((myModMask .|. shiftMask, xK_m), windows focusMaster),
        ((myModMask .|. controlMask, xK_g), sendMessage ToggleGaps),
        ((myModMask .|. controlMask, xK_h), sendMessage $ ModifyGaps incGap),
        ((myModMask .|. controlMask, xK_f), sendMessage $ ModifyGaps decGap),
        ((myModMask .|. controlMask, xK_s), toggleWindowSpacingEnabled),
        ((myModMask .|. controlMask, xK_d), incWindowSpacing 5),
        ((myModMask .|. controlMask, xK_a), decWindowSpacing 5)
      ]
      where
        decGap :: GapSpec -> GapSpec
        decGap = fmap (fmap (subtract 5))

        incGap :: GapSpec -> GapSpec
        incGap = fmap (fmap (+ 5))

type MyLayouts = PerScreen HorizontalMonitorLayouts VerticalMonitorLayouts

type HorizontalMonitorLayouts = (Choose BinarySpacePartition (Choose Tall (Choose TwoPanePersistent (Choose ThreeCol Grid))))
type VerticalMonitorLayouts = (Choose BinarySpacePartition (Choose (Mirror Tall) (Choose Accordion Grid)))

myLayouts :: MyLayouts Window
myLayouts = ifWider minHorizontalWidth horizontalMonitorLayouts verticalMonitorLayouts
  where
    horizontalMonitorLayouts = emptyBSP ||| tall ||| twoPane ||| threeCol ||| Grid
    verticalMonitorLayouts = emptyBSP ||| Mirror tall ||| Accordion ||| invertedGrid
    -- we are using the `ifWider` layoutModifier to have two different sets of
    -- layout modifiers for monitors in horizontal or vertical configuration
    minHorizontalWidth = 2560

    tall = Tall {tallNMaster = 1, tallRatioIncrement = 3 / 100, tallRatio = 3 / 5}
    twoPane = TwoPanePersistent {slaveWin = Nothing, dFrac = 3 / 100, mFrac = 3 / 5}
    threeCol = ThreeCol {threeColNMaster = 1, threeColDelta = 3 / 100, threeColFrac = 1 / 2}
    invertedGrid = GridRatio (9 / 16)

type MyTogglableLayouts = MultiToggle (HCons StdTransformers EOT) MyLayouts

myTogglableLayouts :: MyTogglableLayouts Window
myTogglableLayouts = mkToggle (single FULL) myLayouts

type MyLayoutModifiers a =
  ModifiedLayout
    (ConfigurableBorder Ambiguity)
    (ModifiedLayout AvoidStruts (ModifiedLayout Spacing (ModifiedLayout Gaps a)))

myLayoutModifiers ::
  MyTogglableLayouts Window ->
  (MyLayoutModifiers MyTogglableLayouts) Window
myLayoutModifiers =
  lessBorders OnlyScreenFloat . avoidStruts . spacingLayoutSetup . gapLayoutSetup
  where
    spacingLayoutSetup :: l a -> ModifiedLayout Spacing l a
    spacingLayoutSetup =
      ModifiedLayout $
        Spacing
          { smartBorder = False,
            screenBorder = screenBorder,
            screenBorderEnabled = False,
            windowBorder = windowBorder,
            windowBorderEnabled = True
          }

    gapLayoutSetup :: l a -> ModifiedLayout Gaps l a
    gapLayoutSetup =
      gaps [(U, edgeGap), (R, edgeGap), (D, edgeGap), (L, edgeGap)]

    screenBorder = Border {top = 5, bottom = 5, right = 5, left = 5}
    windowBorder = Border {top = 5, bottom = 5, right = 5, left = 5}
    edgeGap = 4

myManageHook :: ManageHook
myManageHook =
  composeAll
    [ manageDocks,
      className =? "OpenRGB" --> doFloat,
      className =? "Lxappearance" --> doFloat,
      className =? ".solaar-wrapped" --> doFloat,
      className =? "Psensor" --> doFloat,
      className =? "Nm-connection-editor" --> doFloat,
      className =? "Gddccontrol" --> doFloat,
      className =? "feh" --> doFullFloat,
      className =? ".blueman-manager-wrapped" --> doFloat,
      className =? "Pavucontrol" --> doFloat,
      insertPosition End Newer
    ]
