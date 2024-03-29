import React, { useContext } from "react";
import {
  AUDIO_TRACK_CONSTRAINTS,
  SCREENSHARING_TRACK_CONSTRAINTS,
  VIDEO_TRACK_CONSTRAINTS,
} from "../../pages/room/consts";
import { TrackMetadata, useCamera, useMicrophone, useScreenshare, useSetupMedia } from "../../jellyfish.types";
import { UseCameraResult, UseMicrophoneResult, UseScreenshareResult } from "@jellyfish-dev/react-client-sdk";
import { useBlur } from "./BlurProcessor";

export type LocalPeerContext = {
  video: UseCameraResult<TrackMetadata>;
  audio: UseMicrophoneResult<TrackMetadata>;
  screenShare: UseScreenshareResult<TrackMetadata>;
  init: () => void;
  blur: boolean;
  setBlur: (status: boolean) => void;
};

const LocalPeerMediaContext = React.createContext<LocalPeerContext | undefined>(undefined);

type Props = {
  children: React.ReactNode;
};

export const LocalPeerMediaProvider = ({ children }: Props) => {
  const { init } = useSetupMedia({
    camera: {
      trackConstraints: VIDEO_TRACK_CONSTRAINTS,
      defaultTrackMetadata: { active: true, type: "camera" },
      autoStreaming: false,
      preview: true,
      defaultSimulcastConfig: {
        enabled: true,
        activeEncodings: ["l", "m", "h"],
        disabledEncodings: []
      },
    },
    microphone: {
      trackConstraints: AUDIO_TRACK_CONSTRAINTS,
      defaultTrackMetadata: { active: true, type: "audio" },
      autoStreaming: false,
      preview: true,
    },
    screenshare: {
      trackConstraints: SCREENSHARING_TRACK_CONSTRAINTS,
      defaultTrackMetadata: { active: true, type: "screensharing" },
      autoStreaming: false,
      preview: true,
    },
    startOnMount: true,
    storage: true,
  });

  const video = useCamera();
  const audio = useMicrophone();
  const screenShare = useScreenshare();

  const { video: blurVideo, blur, setBlur } = useBlur(video);
  
  return (
    <LocalPeerMediaContext.Provider
      value={{
        video: blur ? blurVideo : video,
        audio,
        screenShare,
        init,
        blur,
        setBlur
      }}
    >
      {children}
    </LocalPeerMediaContext.Provider>
  );
};

export const useLocalPeer = (): LocalPeerContext => {
  const context = useContext(LocalPeerMediaContext);
  if (!context) throw new Error("useLocalPeer must be used within a LocalPeerMediaContext");
  return context;
};
