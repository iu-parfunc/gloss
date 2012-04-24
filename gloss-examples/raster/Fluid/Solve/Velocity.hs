
module Solve.Velocity
        (velocitySteps)
where
import Stage.Diffusion
import Stage.Advection
import Stage.Sources
import Stage.Project
import Model
import Config

-- The pass that sets boundary conditions is buggy and 
-- currently disabled.
-- import Stage.Boundary

velocitySteps 
        :: Config
        -> VelocityField 
        -> Maybe (Source (Float, Float)) 
        -> IO VelocityField

velocitySteps config vf vs 
 = {-# SCC "Solve.velocitySteps" #-}
   do   vf1     <- addSources  (configDelta config) (configVelocity config)  vs vf
        vf2     <- diffusion   (configDelta config) (configViscosity config) vf1 
--        vf3     <- setBoundary vf2
        vf4     <- project     vf2
--        vf5     <- setBoundary vf4
        vf6     <- advection   (configDelta config) vf4 vf4
--        vf7     <- setBoundary vf6
        vf8     <- project     vf6
--        vf'     <- setBoundary vf8
        return  vf8
