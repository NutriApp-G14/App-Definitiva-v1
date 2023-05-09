package com.demo.nutri;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.demo.nutri.config.JWTAuthorizationFilter;




@SpringBootApplication
public class NutriApplication {

	public static void main(String[] args) {
		SpringApplication.run(NutriApplication.class, args);
	}

	@EnableWebSecurity
	@Configuration
	class WebSecurityConfig extends WebSecurityConfigurerAdapter {

		@Override
		protected void configure(HttpSecurity http) throws Exception {
			http.csrf().disable()
				.addFilterAfter(new JWTAuthorizationFilter(), UsernamePasswordAuthenticationFilter.class)
				.authorizeRequests()
				.antMatchers("/users").permitAll()
				.antMatchers("/users/**").permitAll()
				.antMatchers("/users/login").permitAll()
				.antMatchers(HttpMethod.POST, "/users").permitAll()
				.anyRequest().authenticated();
		}
	}


}
	