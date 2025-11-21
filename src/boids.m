function boids_simulation()
    % Simulation parameters
    numBoids = 100;
    canvasWidth = 800;
    canvasHeight = 600;
    visualRange = 75;
    protectedRange = 25;
    
    % Force parameters
    separationFactor = 1.5;
    alignmentFactor = 1.0;
    cohesionFactor = 1.0;
    maxSpeed = 4;
    minSpeed = 2;
    turnFactor = 0.5;
    
    % Initialize boids
    boids = struct();
    for i = 1:numBoids
        boids(i).x = rand() * canvasWidth;
        boids(i).y = rand() * canvasHeight;
        boids(i).vx = (rand() - 0.5) * maxSpeed;
        boids(i).vy = (rand() - 0.5) * maxSpeed;
    end
    
    figure('Position', [100, 100, canvasWidth, canvasHeight]);
    for frame = 1:500
        for i = 1:numBoids
            separationX = 0; separationY = 0;
            alignmentX = 0; alignmentY = 0;
            cohesionX = 0; cohesionY = 0;
            neighbors = 0;
            
            for j = 1:numBoids
                if i == j, continue; end
                
                dx = boids(i).x - boids(j).x;
                dy = boids(i).y - boids(j).y;
                distance = sqrt(dx^2 + dy^2);
                
                if distance < protectedRange && distance > 0
                    separationX = separationX + dx / distance;
                    separationY = separationY + dy / distance;
                end
                
                if distance < visualRange
                    alignmentX = alignmentX + boids(j).vx;
                    alignmentY = alignmentY + boids(j).vy;
                    cohesionX = cohesionX + boids(j).x;
                    cohesionY = cohesionY + boids(j).y;
                    neighbors = neighbors + 1;
                end
            end
            
            if neighbors > 0
                alignmentX = alignmentX / neighbors;
                alignmentY = alignmentY / neighbors;
                boids(i).vx = boids(i).vx + ...
                    (alignmentX - boids(i).vx) * alignmentFactor * 0.05;
                boids(i).vy = boids(i).vy + ...
                    (alignmentY - boids(i).vy) * alignmentFactor * 0.05;
                
                cohesionX = cohesionX / neighbors;
                cohesionY = cohesionY / neighbors;
                boids(i).vx = boids(i).vx + ...
                    (cohesionX - boids(i).x) * cohesionFactor * 0.005;
                boids(i).vy = boids(i).vy + ...
                    (cohesionY - boids(i).y) * cohesionFactor * 0.005;
            end
            
            boids(i).vx = boids(i).vx + separationX * separationFactor * 0.05;
            boids(i).vy = boids(i).vy + separationY * separationFactor * 0.05;
            
            margin = 50;
            if boids(i).x < margin
                boids(i).vx = boids(i).vx + turnFactor;
            end
            if boids(i).x > canvasWidth - margin
                boids(i).vx = boids(i).vx - turnFactor;
            end
            if boids(i).y < margin
                boids(i).vy = boids(i).vy + turnFactor;
            end
            if boids(i).y > canvasHeight - margin
                boids(i).vy = boids(i).vy - turnFactor;
            end
            
            speed = sqrt(boids(i).vx^2 + boids(i).vy^2);
            if speed > maxSpeed
                boids(i).vx = (boids(i).vx / speed) * maxSpeed;
                boids(i).vy = (boids(i).vy / speed) * maxSpeed;
            end
            if speed < minSpeed
                boids(i).vx = (boids(i).vx / speed) * minSpeed;
                boids(i).vy = (boids(i).vy / speed) * minSpeed;
            end
            
            boids(i).x = boids(i).x + boids(i).vx;
            boids(i).y = boids(i).y + boids(i).vy;
        end
        
        clf; hold on;
        for i = 1:numBoids
            angle = atan2(boids(i).vy, boids(i).vx);
            plot(boids(i).x, boids(i).y, 'b.', 'MarkerSize', 8);
            endX = boids(i).x + 10 * cos(angle);
            endY = boids(i).y + 10 * sin(angle);
            plot([boids(i).x, endX], [boids(i).y, endY], 'b-');
        end
        
        xlim([0, canvasWidth]);
        ylim([0, canvasHeight]);
        axis equal;
        title(sprintf('Boids Flocking Simulation - Frame %d', frame));
        drawnow;
    end
end